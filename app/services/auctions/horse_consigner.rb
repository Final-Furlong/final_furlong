module Auctions
  class HorseConsigner < ApplicationService
    class CouldNotConsignHorseError < StandardError; end

    class UnknownConsignmentTypeError < StandardError; end

    def consign_horses(auction:)
      result = Result.new(created: false, auction:, number_consigned: 0, error: nil)

      unless auction.future?
        result.error = error("auction_not_future")
        return result
      end

      if auction.auctioneer.name != "Final Furlong"
        result.error = error("non_game_auction")
        return result
      end

      if auction.consignment_configs.empty?
        result.error = error("no_consignment_configs")
        return result
      end

      number_consigned = 0
      auction.consignment_configs.each do |config|
        consigner_class = case config.horse_type.to_s.downcase
        when "racehorse"
          Auctions::RacehorseConsigner
        when "stud"
          Auctions::StallionConsigner
        when "broodmare"
          Auctions::BroodmareConsigner
        when "yearling"
          Auctions::YearlingConsigner
        when "weanling"
          Auctions::WeanlingConsigner
        else
          raise UnknownConsignmentTypeError
        end
        horse_type_number_consigned = consigner_class.new.base_class.joins(:auction_horse).where(auction_horse: { auction_id: auction.id }).count
        horses = consigner_class.new.select_horses(
          number: config.minimum_count - horse_type_number_consigned,
          stakes_quality: config.stakes_quality,
          min_age: config.minimum_age, max_age: config.maximum_age
        )
        horses.each do |horse|
          creator_result = Auctions::AutoHorseCreator.new.create_horse(auction:, horse:)
          if creator_result.created?
            horse_type_number_consigned += 1
          else
            next
          end
        end
        config.destroy if horse_type_number_consigned >= config.minimum_count
        number_consigned += horse_type_number_consigned
      end
      result.number_consigned = number_consigned
      result.created = true
      result
    end

    class Result
      attr_accessor :created, :auction, :number_consigned, :error

      def initialize(created:, auction:, number_consigned: 0, error: nil)
        @created = created
        @auction = auction
        @number_consigned = number_consigned
        @error = error
      end

      def created?
        @created
      end
    end

    private

    def error(key)
      I18n.t("services.auctions.horse_consigner.#{key}")
    end
  end
end

