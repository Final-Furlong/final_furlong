module Racing
  class TriggerRaceJob < ApplicationJob
    include GoodJob::ActiveJobExtensions::Concurrency

    queue_as :latency_2m

    class RaceRunError < StandardError; end
    class CodeSetupError < StandardError; end
    class PreRaceError < StandardError; end

    retry_on HTTParty::NetworkError
    retry_on RaceRunError

    good_job_concurrency_rule(
      label: -> { arguments.first[:date] },
      total_limit: 2,
      key: -> { self.class.name }
    )

    def perform(date: Date.current, number: 1)
      race = Racing::RaceSchedule.find_by(date:, number:)
      return unless race

      if Racing::RaceEntry.joins(:race).where(race:).needs_pre_race.exists?
        raise PreRaceError.new("Race #{race.id} needs pre-race stuff!")
      end

      if Racing::RaceResult.exists?(date:, number:)
        return
      end

      url = Rails.application.credentials.php_app.url!
      api_key = Rails.application.credentials.php_app.api_key!
      response = HTTParty.post(url, body: { id: race.id }, headers: { "X_API_KEY" => api_key }, format: :plain)
      if response.code == 200 && !max_race?(date:, number:)
        Racing::TriggerRaceJob.set(good_job_labels: [date], wait: 10.seconds).perform_later(date:, number: number + 1)
      else
        body = JSON.parse(response, symbolize_names: true)
        message = body[:message]
        if message == "cannot write to file" || message.starts_with?("Cannot open ")
          raise CodeSetupError.new(message)
        else
          raise RaceRunError.new(message)
        end
      end
    end

    private

    def max_race?(date:, number:)
      number == Racing::RaceSchedule.where(date:).maximum(:number)
    end
  end
end

