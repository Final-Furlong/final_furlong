class Racing::RaceEntryMigrationJob < ApplicationJob
  queue_as :default

  def perform
    deleted_entries = Racing::RaceEntry.past.delete_all
    count = Racing::RaceEntry.count
    MigrateLegacyRaceEntriesService.new.call
    new_count = Racing::RaceEntry.count
    Racing::RaceEntry.counter_culture_fix_counts
    store_job_info(outcome: { new_entries: new_count - count, deleted_entries: })
  end
end

