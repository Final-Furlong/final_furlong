class AddUniqueIdToBroodmareFoalRecords < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :broodmare_foal_records, :horse_id if index_exists? :broodmare_foal_records, :horse_id
    add_index :broodmare_foal_records, :horse_id, unique: true, algorithm: :concurrently
  end
end

