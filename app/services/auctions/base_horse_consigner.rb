module Auctions
  class BaseHorseConsigner < ApplicationService
    def select_horses(number:, min_age:, max_age:, stakes_quality:)
      raise NotImplementedError, "#{self.class.name} must implement select_horses"
    end

    def base_class
      raise NotImplementedError, "#{self.class} needs to implement base_class"
    end

    private

    def base_query
      base_class.game_owned.born.active.where.missing(:auction_horse)
    end

    def consigned_to_auction
      base_class.where.associated(:auction_horse).pluck(:id)
    end
  end
end

