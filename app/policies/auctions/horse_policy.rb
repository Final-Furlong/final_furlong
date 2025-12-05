module Auctions
  class HorsePolicy < AuthenticatedPolicy
    def create?
      return false unless auction.future?
      return true if auction.auctioneer == stable

      auction.outside_horses_allowed
    end

    def show?
      logged_in?
    end

    def bid?
      return false if record.sold_at
      return false unless auction.active?
      if (horse_max = auction.horse_purchase_cap_per_stable.to_i).positive?
        return false if sold_or_current_high_bid_horses(auction:) >= horse_max
      end
      if (money_max = auction.spending_cap_per_stable.to_i).positive?
        return false if money_spent(auction:) >= money_max
      end

      last_bid = record.bids.current_high_bid.first
      return true unless last_bid
      return false if last_bid.sale_time_met?
      return false if stable.available_balance <= last_bid.current_bid

      logged_in?
    end

    def destroy?
      return false unless auction.future?

      record.horse.owner == stable
    end

    private

    def sold_or_current_high_bid_horses(auction:)
      sold_horses = auction.horses.joins(:horse).where(horses: { owner_id: stable.id }).sold.count
      max_bid_horses = Auctions::Bid.joins(:horse).current_high_bid.merge(Auctions::Horse.unsold).where(bidder_id: stable.id).count
      sold_horses + max_bid_horses
    end

    def money_spent(auction:)
      money = 0
      auction.horses.joins(:bids).where(bids: { bidder_id: stable.id }).sold.find_each do |horse|
        money += auction.bids.current_high_bid.where(horse:, bidder_id: stable.id).first&.current_bid.to_i
      end
      money
    end

    def auction
      record.auction
    end
  end
end

