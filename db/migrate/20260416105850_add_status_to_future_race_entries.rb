class AddStatusToFutureRaceEntries < ActiveRecord::Migration[8.1]
  def change
    entry_statuses = %w[entered errored skipped]
    create_enum :future_entry_statuses, entry_statuses

    entry_errors = %w[race_full not_at_track already_entered not_qualified max_entries cannot_afford_shipping cannot_ship_in_time cannot_afford_entry]
    create_enum :future_entry_errors, entry_errors

    safety_assured do
      change_table :future_race_entries do |t|
        t.enum :entry_status, enum_type: "future_entry_statuses", comment: entry_statuses.join(","), index: true
        t.enum :entry_error, enum_type: "future_entry_errors", comment: entry_errors.join(","), index: true
      end
    end
  end
end

