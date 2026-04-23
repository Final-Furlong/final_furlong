module Auctions
  class AutoHorseCreator < ApplicationService
    attr_reader :auction_horse, :auction, :horse

    def create_horse(auction:, horse:)
      @auction = auction
      @horse = horse
      result = Result.new(created: false, auction:, horse: nil)
      unless auction.future?
        result.error = error("auction_not_future")
        return result
      end

      spending_cap = auction.spending_cap_per_stable.to_i.positive? ? auction.spending_cap_per_stable : nil

      auction_horse = auction.horses.build(horse:, sold_at: nil, seller: horse.owner)
      auction_horse.maximum_price = spending_cap if spending_cap&.positive?
      result.horse = auction_horse
      result.created = auction_horse.save
      result.error = auction_horse.errors.full_messages.to_sentence unless result.created?
      result
    end

    class Result
      attr_accessor :auction, :horse, :error, :created

      def initialize(created:, auction:, horse:, error: nil)
        @created = created
        @auction = auction
        @horse = horse
        @error = error
      end

      def created?
        @created
      end
    end

    private

    def error(key)
      I18n.t("services.auctions.horse_creator.#{key}")
    end
  end
end

