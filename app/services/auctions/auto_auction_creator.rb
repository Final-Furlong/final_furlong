module Auctions
  class AutoAuctionCreator < ApplicationService
    def create_auction(auction_params)
      auction = Auction.new(auction_params)
      if auction.valid?(:auto_create) && auction.save
        Result.new(created: true, auction:)
      else
        Result.new(created: false, auction:)
      end
    end

    class Result
      attr_reader :auction

      def initialize(created:, auction:)
        @created = created
        @auction = auction
      end

      def created?
        @created
      end
    end
  end
end

