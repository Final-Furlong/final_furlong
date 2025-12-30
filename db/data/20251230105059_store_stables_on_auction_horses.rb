# frozen_string_literal: true

class StoreStablesOnAuctionHorses < ActiveRecord::Migration[8.1]
  def up
    Auctions::Horse.find_each do |auction_horse|
      auction = auction_horse.auction
      horse = auction_horse.horse
      if auction_horse.sold?
        auction_horse.buyer = auction_horse.bids.current_high_bid&.first&.bidder
        if auction_horse.buyer
          description = "#{auction.title}: Sold "
          id = "(ID# #{horse.legacy_id})"
          budget = Account::Budget.where("description ILIKE ?", "#{description}%")
            .where("description ILIKE ?", "%#{id}%").first
        end
        auction_horse.seller = if budget
          budget.stable
        else
          horse.owner
        end
      else
        auction_horse.seller = horse.owner
      end
      auction_horse.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

