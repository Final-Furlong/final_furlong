class AddCurrentHighBidField < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_column :auction_bids, :current_high_bid, :boolean, default: false, null: false
    add_index :auction_bids, :current_high_bid, algorithm: :concurrently
  end
end

