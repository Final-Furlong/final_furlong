class AddUniqueAuctionHorseIndex < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    remove_index :auction_horses, :horse_id if index_exists? :auction_horses, :horse_id
    remove_index :auction_horses, %i[auction_id horse_id] if index_exists? :auction_horses, %i[auction_id horse_id]
    add_index :auction_horses, :auction_id, algorithm: :concurrently
    add_index :auction_horses, :horse_id, unique: true, algorithm: :concurrently
  end
end

