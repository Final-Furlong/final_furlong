module Auctions
  class BroodmareConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      starting_query = base_query.broodmare.min_age(min_age).max_age(max_age)

      query = if stakes_quality
        gop = starting_query.joins(:broodmare_foal_record).merge(Horses::BroodmareFoalRecord.gold.or(Horses::BroodmareFoalRecord.platinum)).select(:id)
        swf = starting_query.joins(foals: :lifetime_race_record).merge(Racing::LifetimeRaceRecord.stakes_level).select(:id)
        starting_query.where(id: [gop + swf])
      else
        starting_query.joins(:broodmare_foal_record).merge(Horses::BroodmareFoalRecord.not_gold_or_platinum)
      end
      query.random_order.limit(number)
    end
  end
end

