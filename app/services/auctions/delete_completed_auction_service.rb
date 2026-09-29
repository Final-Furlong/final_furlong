module Auctions
  class DeleteCompletedAuctionService < ApplicationService
    class UnprocessedSaleError < StandardError; end

    def call(auction:)
      return unless auction.is_a? Auction
      return unless auction.end_time < DateTime.current

      ActiveRecord::Base.transaction do
        Auctions::Horse.unsold.where.associated(:bids).find_each do |horse|
          winning_bid = Auctions::Bid.current_high_bid.find_by(horse:)
          horse_reserve = horse.reserve_price.to_i
          if winning_bid
            if horse_reserve.positive? && winning_bid.current_bid >= horse_reserve
              result = Auctions::HorseSeller.new.process_sale(bid: winning_bid, disable_job_trigger: true)
              raise UnprocessedSaleError, "Could not sell horse #{horse.id}" unless result.sold?
            end
          end
        end

        Auctions::Bid.where(auction:).destroy_all
        Auctions::Horse.where(auction:).destroy_all
        auction.destroy!
      end
    end
  end
end

