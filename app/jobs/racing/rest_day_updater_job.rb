class Racing::RestDayUpdaterJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :default

  def perform
    return if run_today?

    horses = 0

    step :process do |step|
      Horses::Horse.racehorse.joins(:race_metadata).where(race_metadata: { at_home: true, in_transit: false }).find_each(start: step.cursor) do |horse|
        data = horse.race_metadata
        data.update(rest_days_since_last_race: data.rest_days_since_last_race.to_i + 1, last_rested_at: Date.current)
        horses += 1
        step.advance! from: horse.id
      end
    end

    store_job_info(outcome: { horses: })
    Shipping::ProcessArrivalsJob.perform_later
  end
end

