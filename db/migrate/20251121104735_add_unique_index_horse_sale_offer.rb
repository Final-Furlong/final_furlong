class AddUniqueIndexHorseSaleOffer < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :sale_offers, column: :horse_id, if_exists: true
    add_index :sale_offers, :horse_id, unique: true, algorithm: :concurrently
  end
end

