class AddEntriesCountToRaceSchedules < ActiveRecord::Migration[8.1]
  def self.up
    add_column :race_schedules, :entries_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :race_schedules, :entries_count
  end
end

