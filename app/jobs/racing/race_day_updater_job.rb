class Racing::RaceDayUpdaterJob < ApplicationJob
  queue_as :default

  def perform(date:)
    result = Racing::RaceRecordUpdater.new.update_records(date:)
    injuries = Racing::InjuryUpdater.new.update_records(date:)
    result[:injuries] = injuries
    Racing::RaceEntry.joins(:race).where(race: { date: }).delete_all
    Racing::RaceScheduleUpdater.new.update_schedule
    store_job_info(outcome: result)
  end
end

