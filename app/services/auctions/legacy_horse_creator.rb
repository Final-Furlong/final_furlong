module Auctions
  class LegacyHorseCreator < ApplicationService
    attr_reader :auction

    def create_horse(auction:, legacy_horse_id:)
      @auction = auction
      result = Result.new(created: false, auction:, horse: nil)
      unless auction.future?
        result.error = error("auction_not_future")
        return result
      end

      spending_cap = auction.spending_cap_per_stable.to_i.positive? ? auction.spending_cap_per_stable : nil
      horse = Horses::Horse.find_by(legacy_id: legacy_horse_id)
      result.error = error("horse_not_found") unless horse

      auction_horse = auction.horses.build(horse:, sold_at: nil, seller: horse&.owner)
      auction_horse.maximum_price = spending_cap if spending_cap&.positive?
      result.horse = auction_horse
      result.created = if auction_horse.save!
        true
      else
        false
      end
      result
    end

    class Result
      attr_accessor :auction, :horse, :created, :error

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
      I18n.t("services.auctions.legacy_horse_creator.#{key}")
    end
  end
end

