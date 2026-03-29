class Racing::FutureEntryMigrationJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    deleted_entries = Racing::FutureRaceEntry.past.delete_all
    count = Racing::FutureRaceEntry.count
    MigrateLegacyFutureRaceEntriesService.new.call
    new_count = Racing::FutureRaceEntry.count
    store_job_info(outcome: { new_entries: new_count - count, deleted_entries: })
  end
end

