module Auctions
  class WeanlingConsigner < BaseHorseConsigner
    def select_horses(number:, min_age: 0, max_age: 0, stakes_quality: false)
      query = base_query.weanling
      if stakes_quality
        query = query.joins(dam: :lifetime_race_record).merge(Racing::LifetimeRaceRecord.stakes_level)
        query.random_order.limit(number)
      else
        non_stakes = base_query.joins(dam: :lifetime_race_record).merge(Racing::LifetimeRaceRecord.not_stakes_level).random_order.limit(number)
        missing_dam = base_query.where.missing(:dam).random_order.limit(number)
        horses = non_stakes + missing_dam
        horses.shuffle.slice(0, number)
      end
    end
  end
end

