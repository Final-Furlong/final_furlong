module Horses
  class BroodmareFoalRecord < ApplicationRecord
    include BreedRankable

    self.table_name = "broodmare_foal_records"
    self.primary_key = :horse_id

    belongs_to :mare, class_name: "Horse", foreign_key: :horse_id, inverse_of: :broodmare_foal_record

    def readonly?
      true
    end

    def self.refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
    end

    def self.populated?
      Scenic.database.populated?(table_name)
    end

    def living_foals_count
      born_foals_count - stillborn_foals_count
    end

    def raced_foals_string
      string_with_percent(raced_foals_count, living_foals_count)
    end

    def winning_foals_string
      string_with_percent(winning_foals_count, raced_foals_count)
    end

    def stakes_winning_foals_string
      string_with_percent(stakes_winning_foals_count, winning_foals_count)
    end

    def multi_stakes_winning_foals_string
      string_with_percent(multi_stakes_winning_foals_count, stakes_winning_foals_count)
    end

    def millionaire_foals_string
      string_with_percent(millionaire_foals_count, raced_foals_count)
    end

    def earnings_string
      earnings = (raced_foals_count.positive? && total_foal_earnings.positive?) ? total_foal_earnings / raced_foals_count : 0
      Game::MoneyFormatter.new(earnings).to_s
    end

    private

    def string_with_percent(value, base_value)
      if value.positive?
        "#{value} (#{(value.fdiv(base_value) * 100).floor}%)"
      else
        "0 (0%)"
      end
    end
  end
end

# == Schema Information
#
# Table name: broodmare_foal_records
# Database name: primary
#
#  average_earnings                 :decimal(, )
#  born_foals_count                 :integer
#  breed_ranking                    :text
#  breed_ranking_points             :decimal(, )
#  millionaire_foals_count          :integer
#  multi_millionaire_foals_count    :integer
#  multi_stakes_winning_foals_count :integer
#  next_due_date                    :date
#  raced_foals_count                :integer
#  stakes_winning_foals_count       :integer
#  stillborn_foals_count            :integer
#  total_foal_earnings              :bigint
#  total_foal_points                :integer
#  total_foal_races                 :integer
#  unborn_foals_count               :integer
#  winning_foals_count              :integer
#  horse_id                         :bigint           primary key, uniquely indexed
#  in_foal_stud_id                  :bigint
#
# Indexes
#
#  index_broodmare_foal_records_on_horse_id  (horse_id) UNIQUE
#

