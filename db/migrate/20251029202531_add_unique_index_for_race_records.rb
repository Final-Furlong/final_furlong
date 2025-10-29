class AddUniqueIndexForRaceRecords < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :race_records, :horse_id if index_exists? :race_records, :horse_id
    add_index :race_records, %i[horse_id year result_type], unique: true, algorithm: :concurrently
  end
end

