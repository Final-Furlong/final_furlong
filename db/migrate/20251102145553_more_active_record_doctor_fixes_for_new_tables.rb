class MoreActiveRecordDoctorFixesForNewTables < ActiveRecord::Migration[8.1]
  def change
    change_column_null :budget_transactions, :stable_id, false
    change_column_null :horse_attributes, :horse_id, false

    remove_index :race_records, column: :horse_id, if_exists: true
    remove_index :track_surfaces, column: :racetrack_id, if_exists: true
  end
end

