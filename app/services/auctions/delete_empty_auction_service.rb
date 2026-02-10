module Auctions
  class DeleteEmptyAuctionService < ApplicationService
    def call(auction:)
      return unless auction.is_a? Auction
      return unless auction.start_time.to_date == Date.current + 1.day

      if auction.horses.count < 5
        if auction.auctioneer.name != Config::Game.stable
          ActiveRecord::Base.transaction do
            Auctions::Bid.where(auction:).delete_all
            Auctions::Horse.where(auction:).delete_all
            auction.destroy!
          end
        end
      end
    end
  end
end

