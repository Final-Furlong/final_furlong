module Auctions
  class BroodmareConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      starting_query = base_query.min_age(min_age).max_age(max_age).left_outer_joins(:next_foal)

      query = if stakes_quality
        stakes_level(starting_query)
      else
        not_stakes_level(starting_query, number)
      end
      query.sort(next_foal: { id: { asc: :nulls_last } }).random_order.limit(number)
    end

    def not_stakes_level(query, _number)
      query.left_outer_joins(:foal_record).merge(Horses::Broodmare::FoalRecord.not_gold_or_platinum)
    end

    def stakes_level(query)
      gop = query.joins(:foal_record).merge(Horses::Broodmare::FoalRecord.gold.or(Horses::Broodmare::FoalRecord.platinum)).select(:id)
      swf = query.joins(foals: :lifetime_race_record).merge(Racing::LifetimeRaceRecord.stakes_level).select(:id)
      query.where(id: [gop + swf])
    end

    def base_class
      Horses::Horse::Broodmare
    end
  end
end

