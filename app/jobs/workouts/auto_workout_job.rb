class Workouts::AutoWorkoutJob < ApplicationJob
  queue_as :low_priority

  def perform(date:)
    return if run_today?

    result = Racing::RaceRecordUpdater.new.update_records(date:)
    Racing::RaceEntry.joins(:race).where(race: { date: }).delete_all
    Racing::RaceScheduleUpdater.new.update_schedule
    store_job_info(outcome: result)
  end
end

