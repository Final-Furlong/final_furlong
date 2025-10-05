class AddAuctionTitleIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :auctions, "lower((title)::text)", name: "index_auctions_on_title", unique: true
  end
end

