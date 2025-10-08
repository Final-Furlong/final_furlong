module Auctions
  class StallionConsigner < ApplicationService
    def select_horses(number:, min_age: 2, max_age: 3, stakes_quality: false)
      quality_stallions = Legacy::HorseBreedRanking.gold.or(Legacy::HorseBreedRanking.platinum).select(:Horse)

      query = Legacy::Horse.game_owned.sellable.stallion.non_famous_stud.minimum_age(min_age).maximum_age(max_age)
      query = if stakes_quality
        query.where(ID: quality_stallions)
      else
        query.where.not(ID: quality_stallions)
      end
      query.random_order.limit(number)
    end
  end
end

