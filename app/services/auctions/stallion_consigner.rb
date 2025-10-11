module Auctions
  class StallionConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      quality_stallions = Legacy::HorseBreedRanking.gold.or(Legacy::HorseBreedRanking.platinum).select(:Horse)

      query = base_query.stallion.non_famous_stud.age_between(min_age, max_age).where.not(ID: consigned_to_auction)
      query = if stakes_quality
        query.where(ID: quality_stallions)
      else
        query.where.not(ID: quality_stallions)
      end
      query.random_order.limit(number)
    end
  end
end

