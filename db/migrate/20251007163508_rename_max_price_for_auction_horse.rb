class RenameMaxPriceForAuctionHorse < ActiveRecord::Migration[8.0]
  def change
    add_column :auction_horses, :maximum_price, :integer
  end
end

