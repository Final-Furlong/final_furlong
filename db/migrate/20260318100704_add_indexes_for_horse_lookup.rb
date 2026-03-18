class AddIndexesForHorseLookup < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :racehorse_metadata, :location_string, algorithm: :concurrently
    add_index :horses, %i[date_of_birth owner_id], where: "leaser_id IS NULL", algorithm: :concurrently
    add_index :horses, %i[date_of_birth leaser_id], where: "leaser_id IS NOT NULL", algorithm: :concurrently
  end
end

