module Auctions
  class FoalAuctionCreator < ApplicationService
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
      create_yearling_config
      create_weanling_config
    end

    def create_yearling_config
      Auctions::ConsignmentConfig.create!(
        auction:,
        horse_type: "yearling",
        minimum_age: 1,
        maximum_age: 1,
        minimum_count: 75,
        stakes_quality: false
      )
    end

    def create_weanling_config
      Auctions::ConsignmentConfig.create!(
        auction:,
        horse_type: "weanling",
        minimum_age: 0,
        maximum_age: 0,
        minimum_count: 50,
        stakes_quality: false
      )
    end
  end
end

