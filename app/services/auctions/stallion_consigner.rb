module Auctions
  class StallionConsigner < BaseHorseConsigner
    def select_horses(number:, min_age:, max_age:, stakes_quality: false)
      starting_query = base_query.stallion.min_age(min_age).max_age(max_age).where.missing(:famous_stud)
      query = if stakes_quality
        starting_query.joins(:stud_foal_record).merge(Horses::StudFoalRecord.gold.or(Horses::StudFoalRecord.platinum)).select(:id)
      else
        starting_query.joins(:stud_foal_record).merge(Horses::StudFoalRecord.not_gold_or_platinum)
      end
      query.random_order.limit(number)
    end
  end
end

