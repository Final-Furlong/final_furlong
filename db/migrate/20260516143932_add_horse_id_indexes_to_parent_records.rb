class AddHorseIdIndexesToParentRecords < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :broodmare_foal_records, :horse_id, unique: true, algorithm: :concurrently
    add_index :stud_foal_records, :horse_id, unique: true, algorithm: :concurrently
  end
end

