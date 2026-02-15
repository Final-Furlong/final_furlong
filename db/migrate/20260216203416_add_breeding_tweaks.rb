class AddBreedingTweaks < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :breedings, :legacy_id, unique: true, algorithm: :concurrently
    change_column_null :breedings, :mare_id, false
  end
end

