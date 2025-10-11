class RemoveMaxPriceFromAuctionHorses < ActiveRecord::Migration[8.0]
  def change
    safety_assured { remove_column :auction_horses, :max_price, :integer }
  end
end

