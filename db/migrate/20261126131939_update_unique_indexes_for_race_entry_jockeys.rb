class UpdateUniqueIndexesForRaceEntryJockeys < ActiveRecord::Migration[8.1]
  def change
    remove_index :race_entries, %i[horse_id first_jockey_id second_jockey_id third_jockey_id], if_exists: true
    add_index :race_entries, %i[horse_id race_id first_jockey_id second_jockey_id third_jockey_id], unique: true, if_not_exists: true
  end
end

