module Auctions
  class TwoYearOldAuctionCreator < ApplicationService
    attr_reader :auction

    def create_auction(auction_params)
      @auction = Auction.new(auction_params)
      ActiveRecord::Base.transaction do
        if auction.valid?(:auto_create) && auction.save!
          create_racehorse_config
          Result.new(created: true, auction:)
        else
          Result.new(created: false, auction:)
        end
      rescue ActiveRecord::ActiveRecordError
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

    private

    def create_racehorse_config
      Auctions::ConsignmentConfig.create!(
        auction:,
        horse_type: "racehorse",
        minimum_age: 2,
        maximum_age: 2,
        minimum_count: Config::Auctions.dig(:two_year_old_auction, :count),
        stakes_quality: false
      )
    end
  end
end

