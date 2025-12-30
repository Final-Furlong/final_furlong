class AddStablesToAuctionHorse < ActiveRecord::Migration[8.1]
  def change
    add_reference :auction_horses, :seller, foreign_key: { to_table: :stables }
    add_reference :auction_horses, :buyer, foreign_key: { to_table: :stables }

    add_index :auction_horses, :seller_id, if_not_exists: true, algorithm: :concurrently
    add_index :auction_horses, :buyer_id, if_not_exists: true, algorithm: :concurrently
  end
end

