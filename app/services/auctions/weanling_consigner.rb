module Auctions
  class WeanlingConsigner < BaseHorseConsigner
    def select_horses(number:, min_age: 0, max_age: 0, stakes_quality: false)
      query = base_query.weanling
      if stakes_quality
        query = stakes_level(query)
        query.random_order.limit(number)
      else
        horses = not_stakes_level(query, number)
        horses.shuffle.slice(0, number)
      end
    end

    def not_stakes_level(query, number)
      non_stakes = query.joins(dam: :lifetime_race_record).merge(Racing::LifetimeRaceRecord.not_stakes_level).random_order.limit(number)
      missing_dam = query.where.missing(:dam).random_order.limit(number)
      non_stakes + missing_dam
    end

    def stakes_level(query)
      query.joins(dam: :lifetime_race_record).merge(Racing::LifetimeRaceRecord.stakes_level)
    end

    def base_class
      Horses::Horse::Foal
    end
  end
end

