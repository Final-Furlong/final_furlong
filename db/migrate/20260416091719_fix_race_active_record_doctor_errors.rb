class FixRaceActiveRecordDoctorErrors < ActiveRecord::Migration[8.1]
  def change
    change_column_null :future_race_entries, :stable_id, false
    change_column_null :race_entries, :stable_id, false
    remove_index :race_entries, %i[horse_id first_jockey_id second_jockey_id third_jockey_id], if_exists: true
    add_index :race_entries, %i[horse_id first_jockey_id second_jockey_id third_jockey_id], unique: true, algorithm: :concurrently
    remove_index :race_entries, %i[horse_id first_jockey_id second_jockey_id], if_exists: true
    remove_index :race_entries, %i[horse_id first_jockey_id third_jockey_id], if_exists: true
  end
end

