class AddUniqueFoalIndexesForBreedings < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :breedings, :first_foal_id, if_exists: true
    add_index :breedings, :first_foal_id, unique: true, algorithm: :concurrently
    remove_index :breedings, :second_foal_id, if_exists: true
    add_index :breedings, :second_foal_id, unique: true, algorithm: :concurrently
  end
end

