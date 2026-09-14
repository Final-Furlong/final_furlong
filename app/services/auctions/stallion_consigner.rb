module Auctions
  class StallionConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      starting_query = base_query.min_age(min_age).max_age(max_age).where.missing(:famous_stud)
      query = if stakes_quality
        stakes_level(starting_query)
      else
        not_stakes_level(starting_query, number)
      end
      query.random_order.limit(number)
    end

    def not_stakes_level(query, _number)
      query.left_outer_joins(:foal_record).merge(Horses::Stud::FoalRecord.not_gold_or_platinum)
    end

    def stakes_level(query)
      query.joins(:foal_record).merge(Horses::Stud::FoalRecord.gold.or(Horses::Stud::FoalRecord.platinum)).select(:id)
    end

    def base_class
      Horses::Horse::Stud
    end
  end
end

