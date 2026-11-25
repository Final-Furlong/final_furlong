class CreateUniqueColumnsForViews < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :broodmare_foal_records, :horse_id, unique: true, if_not_exists: true, algorithm: :concurrently
    add_index :stud_foal_records, :horse_id, unique: true, if_not_exists: true, algorithm: :concurrently
  end
end

