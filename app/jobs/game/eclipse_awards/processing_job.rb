class Game::EclipseAwards::ProcessingJob < ApplicationJob
  queue_as :latency_30s

  retry_on ActiveRecord::RecordInvalid

  def perform(year: Date.current.year - 1)
    batch = GoodJob::Batch.new
    entries = Racing::RaceEntry.where(date: tomorrow).needs_pre_race
    Racing::RaceSchedule.where(date: tomorrow).joins(:entries).where(entries:).distinct.find_each do |race|
      batch.add(Racing::PreRace::RaceJob.perform_later(id: race.id))
    end
    batch.enqueue
    store_job_info(outcome: { races: })
  end
end
