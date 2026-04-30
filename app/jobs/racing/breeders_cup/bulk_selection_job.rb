class Racing::BreedersCup::BulkSelectionJob < ApplicationJob
  queue_as :latency_30s

  def perform
    bc_race = Racing::RaceSchedule.breeders_cup.current_year.first
    return unless bc_race
    deadline = bc_race.entry_open_date - Config::Racing.breeders_cup_nomination_deadline_days.days
    return unless Date.current == deadline

    horses = 0
    races = 0

    batch = GoodJob::Batch.new
    Racing::RaceSchedule.breeders_cup.current_year.find_each do |race|
      batch.add(Racing::BreedersCup::SelectionJob.perform_later(id: race.id))
      races += 1
    end
    batch.enqueue
    store_job_info(outcome: { horses:, races: })
  end
end

