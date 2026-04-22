module Auctions
  class BaseHorseConsigner < ApplicationService
    def select_horses(number:, min_age:, max_age:, stakes_quality:)
      raise NotImplementedError, "#{self.class.name} must implement select_horses"
    end

    private

    def base_query
      Horses::Horse.game_owned.where.missing(:auction_horse)
    end

    def consigned_to_auction
      Horses::Horse.where.associated(:auction_horse).pluck(:id)
    end
  end
end

