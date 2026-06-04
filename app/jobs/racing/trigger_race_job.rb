module Racing
  class TriggerRaceJob < ApplicationJob
    queue_as :default

    retry_on HTTParty::NetworkError

    def perform(date: Date.current, number: 1)
      return unless ENV.fetch("USE_PHP_API", "false") == "true"

      race = Racing::RaceSchedule.find_by(date:, number:)
      return unless race

      HTTParty.post(Rails.application.credentials.dig(:php_app, :url),
        body: { id: race.id },
        headers: { "X_API_KEY" => Rails.application.credentials.dig(:php_app, :api_key) })
    end
  end
end

