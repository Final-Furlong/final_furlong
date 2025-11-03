module Auctions
  class BroodmareConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      quality_mares = Legacy::HorseBreedRanking.gold.or(Legacy::HorseBreedRanking.platinum).select(:Horse)
      stakes_dams = Legacy::Horse.where(ID: Legacy::RaceRecord.stakes_quality.select(:Horse).distinct).select(:Dam)

      starting_query = base_query.broodmare.age_between(min_age, max_age).where.not(ID: consigned_to_auction)
      query = if stakes_quality
                starting_query.where(ID: quality_mares)
              else
                starting_query.where.not(ID: quality_mares)
              end
      query = query.or(starting_query.where(ID: stakes_dams)) if stakes_quality
      query.random_order.limit(number)
    end
  end
end

