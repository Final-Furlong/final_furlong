class Racing::RaceFiller::ProcessingJob < ApplicationJob
  queue_as :latency_5m

  def perform(tomorrow: Date.tomorrow, stable_name: Config::Game.stable)
    races = 0

    owner = Account::Stable.find_by(name: stable_name)
    return unless owner

    batch = GoodJob::Batch.new
    Racing::RaceSchedule.includes(:track_surface).where(date: tomorrow).where.not(race_type: "stakes").where(entries_count: ...Config::Racing.minimum_horses).find_each do |race|
      batch.add(Racing::RaceFiller::RaceJob.perform_later(id: race.id))
      races += 1
    end

    Racing::RaceSchedule.where(date: tomorrow).where(race_type: "stakes").where(entries_count: ...Config::Racing.minimum_horses_stakes).find_each do |race|
      batch.add(Racing::RaceFiller::RaceJob.perform_later(id: race.id))
      races += 1
    end
    batch.enqueue
    store_job_info(outcome: { races: })
  end
end

