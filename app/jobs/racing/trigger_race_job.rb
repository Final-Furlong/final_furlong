module Racing
  class TriggerRaceJob < ApplicationJob
    queue_as :latency_2m

    class RaceRunError < StandardError; end
    class CodeSetupError < StandardError; end
    class PreRaceError < StandardError; end

    retry_on HTTParty::NetworkError
    retry_on RaceRunError

    good_job_concurrency_rule(
      label: -> { arguments.first[:date] },
      total_limit: 1
    )

    def perform(date: Date.current, number: 1)
      return unless ENV.fetch("USE_PHP_API", "false") == "true"

      race = Racing::RaceSchedule.find_by(date:, number:)
      return unless race

      if Racing::RaceEntry.joins(:race).where(race:).needs_pre_race.exists?
        raise PreRaceError.new("Race #{race.id} needs pre-race stuff!")
      end

      response = HTTParty.post(Rails.application.credentials.dig(:php_app, :url),
        body: { id: race.id },
        headers: { "X_API_KEY" => Rails.application.credentials.dig(:php_app, :api_key) },
        format: :plain)
      unless response.code == 200
        body = JSON.parse(response, symbolize_names: true)
        message = body[:message]
        if message == "cannot write to file" || message.starts_with?("Cannot open ")
          raise CodeSetupError.new(message)
        else
          raise RaceRunError.new(message)
        end
      end
    end
  end
end

