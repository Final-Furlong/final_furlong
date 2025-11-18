class AddBidTimeToAuctionBids < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    safety_assured do
      add_column :auction_bids, :bid_at, :datetime, null: false, default: -> { "now()" }
    end
    add_index :auction_bids, :bid_at, algorithm: :concurrently
  end
end

