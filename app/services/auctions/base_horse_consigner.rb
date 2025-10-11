module Auctions
  class BaseHorseConsigner < ApplicationService
    def select_horses(number:, min_age:, max_age:, stakes_quality:)
      raise NotImplementedError, "#{self.class.name} must implement select_horses"
    end

    private

    def base_query
      Legacy::Horse.game_owned.where.missing(:auction_consignment)
    end

    def consigned_to_auction
      Horses::Horse.where.associated(:auction_horse).pluck(:legacy_id)
    end
  end
end

