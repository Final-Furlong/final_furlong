module Auctions
  class SelectAuctionCreator < ApplicationService
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
      create_racehorse_config
      create_stallion_config
      create_broodmare_config
      create_yearling_config
      create_weanling_config
    end

    def create_racehorse_config
      Auctions::ConsignmentConfig.create!(
        auction:,
        horse_type: "racehorse",
        minimum_age: 2,
        maximum_age: 4,
        minimum_count: 50,
        stakes_quality: true
      )
    end

    def create_stallion_config
      Auctions::ConsignmentConfig.create!(
        auction:,
        horse_type: "stud",
        minimum_age: 4,
        maximum_age: 10,
        minimum_count: 2,
        stakes_quality: true
      )
    end

    def create_broodmare_config
      Auctions::ConsignmentConfig.create!(
        auction:,
        horse_type: "broodmare",
        minimum_age: 4,
        maximum_age: 12,
        minimum_count: 50,
        stakes_quality: true
      )
    end

    def create_yearling_config
      Auctions::ConsignmentConfig.create!(
        auction:,
        horse_type: "yearling",
        minimum_age: 1,
        maximum_age: 1,
        minimum_count: 30,
        stakes_quality: true
      )
    end

    def create_weanling_config
      Auctions::ConsignmentConfig.create!(
        auction:,
        horse_type: "weanling",
        minimum_age: 0,
        maximum_age: 0,
        minimum_count: 20,
        stakes_quality: true
      )
    end
  end
end

