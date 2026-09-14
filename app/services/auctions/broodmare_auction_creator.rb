module Auctions
  class BroodmareAuctionCreator < ApplicationService
    attr_reader :auction

    def create_auction(auction_params)
      @auction = Auction.new(auction_params)
      ActiveRecord::Base.transaction do
        if auction.valid?(:auto_create) && auction.save!
          create_configs
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

    def create_configs
      create_broodmare_configs
    end

    def create_broodmare_configs
      Auctions::ConsignmentConfig.create(
        auction:,
        horse_type: "broodmare",
        minimum_age: Config::Auctions.dig(:broodmare_auction, :min_age),
        maximum_age: Config::Auctions.dig(:broodmare_auction, :max_age),
        minimum_count: Config::Auctions.dig(:broodmare_auction, :regular_mares),
        stakes_quality: false
      )
      Auctions::ConsignmentConfig.create(
        auction:,
        horse_type: "broodmare",
        minimum_age: Config::Auctions.dig(:broodmare_auction, :min_age),
        maximum_age: Config::Auctions.dig(:broodmare_auction, :max_age),
        minimum_count: Config::Auctions.dig(:broodmare_auction, :stakes_mares),
        stakes_quality: true
      )
    end
  end
end

