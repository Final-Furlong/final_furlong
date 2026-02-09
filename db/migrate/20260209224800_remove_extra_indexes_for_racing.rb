class RemoveExtraIndexesForRacing < ActiveRecord::Migration[8.1]
  def change
    remove_index :race_options, column: %i[first_jockey_id second_jockey_id
      third_jockey_id], unique: true, if_exists: true
  end
end

