class AddUniqueIndexCurrentHighBid < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :auction_bids, column: :horse_id, if_exists: true
    add_index :auction_bids, :horse_id, where: "current_high_bid = TRUE", unique: true, algorithm: :concurrently
  end
end

