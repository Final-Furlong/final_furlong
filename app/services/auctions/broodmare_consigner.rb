module Auctions
  class BroodmareConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      starting_query = base_query.min_age(min_age).max_age(max_age)

      query = if stakes_quality
        gop = starting_query.joins(:foal_record).merge(Horses::Broodmare::FoalRecord.gold.or(Horses::Broodmare::FoalRecord.platinum)).select(:id)
        swf = starting_query.joins(foals: :lifetime_race_record).merge(Racing::LifetimeRaceRecord.stakes_level).select(:id)
        starting_query.where(id: [gop + swf])
      else
        starting_query.left_outer_joins(:foal_record).merge(Horses::Broodmare::FoalRecord.not_gold_or_platinum)
      end
      query.random_order.limit(number)
    end

    def base_class
      Horses::Horse::Broodmare
    end
  end
end

