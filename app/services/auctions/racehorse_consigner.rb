module Auctions
  class RacehorseConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      stakes_horses = Legacy::RaceRecord.stakes_quality.select(:Horse).distinct

      query = base_query.racehorse.age_between(min_age, max_age).where.not(ID: consigned_to_auction)
      query = if stakes_quality
                query.where(ID: stakes_horses)
              else
                query.where.not(ID: stakes_horses)
              end
      query.random_order.limit(number)
    end
  end
end

