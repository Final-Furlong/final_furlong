class AddUniqueIndexToStudFoalRecord < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :stud_foal_records, column: :horse_id, if_exists: true
    add_index :stud_foal_records, :horse_id, unique: true, algorithm: :concurrently
  end
end

