module Auctions
  class RacehorseConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      query = base_query.racehorse.min_age(min_age).max_age(max_age)
      if stakes_quality
        query = query.joins(:lifetime_race_record).merge(Racing::LifetimeRaceRecord.stakes_level)
        query.random_order.limit(number)
      else
        horses1 = query.where.missing(:lifetime_race_record).random_order.limit(number).to_a
        horses2 = query.joins(:lifetime_race_record).merge(Racing::LifetimeRaceRecord.not_stakes_level).to_a
        horses = horses1 + horses2
        horses.shuffle.slice(0, number)
      end
    end
  end
end

