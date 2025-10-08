module Auctions
  class WeanlingConsigner < ApplicationService
    def select_horses(number:, min_age: 0, max_age: 0, stakes_quality: false)
      stakes_horses = Legacy::RaceRecord.stakes_quality.select(:Horse)

      query = Legacy::Horse.game_owned.sellable.weanling.minimum_age(min_age).maximum_age(max_age)
      query = if stakes_quality
        query.where(Dam: stakes_horses)
      else
        query.where.not(Dam: stakes_horses).or(query.where(Dam: nil))
      end
      query.random_order.limit(number)
    end
  end
end

