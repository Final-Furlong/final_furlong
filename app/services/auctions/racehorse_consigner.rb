module Auctions
  class RacehorseConsigner < ApplicationService
    def select_horses(number:, min_age: 2, max_age: 3, stakes_quality: false)
      stakes_horses = Legacy::RaceRecord.stakes_quality.select(:Horse)

      query = Legacy::Horse.game_owned.sellable.racehorse.minimum_age(min_age).maximum_age(max_age)
      query = if stakes_quality
        query.where(ID: stakes_horses)
      else
        query.where.not(ID: stakes_horses)
      end
      query.random_order.limit(number)
    end
  end
end

