module Auctions
  class DeleteCompletedAuctionService < ApplicationService
    class UnprocessedSaleError < StandardError; end

    def call(auction:)
      return unless auction.is_a? Auction
      return unless auction.end_time < DateTime.current

      ActiveRecord::Base.transaction do
        Auctions::Horse.unsold.where.associated(:bids).find_each do |horse|
          winning_bid = Auctions::Bid.winning.find_by(horse:)
          result = Auctions::HorseSeller.new.process_sale(bid: winning_bid)
          raise UnprocessedSaleError, "Could not sell horse #{horse.id}" unless result.sold?
        end

        Auctions::Bid.where(auction:).destroy_all
        Auctions::Horse.where(auction:).destroy_all
        auction.destroy!
      end
    end
  end
end

