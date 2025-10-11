module Auctions
  class WeanlingConsigner < BaseHorseConsigner
    def select_horses(number:, min_age: 0, max_age: 0, stakes_quality: false)
      stakes_horses = Legacy::RaceRecord.stakes_quality.select(:Horse).distinct

      query = base_query.weanling.age_between(min_age, max_age).where.not(ID: consigned_to_auction)
      query = if stakes_quality
        query.where(Dam: stakes_horses)
      else
        query.where.not(Dam: stakes_horses).or(query.where(Dam: nil))
      end
      query.random_order.limit(number)
    end
  end
end

