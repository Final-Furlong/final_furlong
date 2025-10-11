module Auctions
  class BroodmareConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      quality_mares = Legacy::HorseBreedRanking.gold.or(Legacy::HorseBreedRanking.platinum).select(:Horse)

      query = base_query.broodmare.age_between(min_age, max_age).where.not(ID: consigned_to_auction)
      query = if stakes_quality
        query.where(ID: quality_mares)
      else
        query.where.not(ID: quality_mares)
      end
      query.random_order.limit(number)
    end
  end
end

