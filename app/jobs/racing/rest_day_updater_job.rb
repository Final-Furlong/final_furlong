class Racing::RestDayUpdaterJob < ApplicationJob
  queue_as :latency_5m

  def perform
    return if run_today?

    horses = 0

    Horses::Horse::Racehorse.joins(:racehorse_metadata).where(racehorse_metadata: { at_home: true, in_transit: false }).find_each do |horse|
      data = horse.racehorse_metadata
      data.update(rest_days_since_last_race: data.rest_days_since_last_race.to_i + 1, last_rested_at: Date.current)
      horses += 1
    end

    store_job_info(outcome: { horses: })
    Shipping::ProcessArrivalsJob.perform_later
  end
end

