module Horses::Stud
  class FoalRecord < ApplicationRecord
    include BreedRankable

    self.table_name = "stud_foal_records"
    self.primary_key = :horse_id

    belongs_to :stud, class_name: "Horses::Horse::Stud", foreign_key: :horse_id, inverse_of: :foal_record

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
      born_foals_count.to_i - stillborn_foals_count.to_i
    end

    def living_foals_string
      value = living_foals_count.to_i.to_s
      if crops_count.to_i.positive?
        crop_string = I18n.t("activerecord.attributes.horses/stud_foal_record.crop")
        value += " (#{crops_count} #{crop_string.downcase.pluralize(crops_count)})"
      end
      value
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
      earnings = (raced_foals_count.to_i.positive? && total_foal_earnings.to_i.positive?) ? total_foal_earnings / raced_foals_count : 0
      Game::MoneyFormatter.new(earnings).to_s
    end

    private

    def string_with_percent(value, base_value)
      if value.to_i.positive?
        "#{value} (#{(value.fdiv(base_value) * 100).floor}%)"
      else
        "0 (0%)"
      end
    end
  end
end

# == Schema Information
#
# Table name: stud_foal_records
# Database name: primary
#
#  average_earnings                 :decimal(, )
#  born_foals_count                 :integer
#  breed_ranking                    :text
#  breed_ranking_points             :decimal(, )
#  crops_count                      :bigint
#  millionaire_foals_count          :integer
#  multi_millionaire_foals_count    :integer
#  multi_stakes_winning_foals_count :integer
#  raced_foals_count                :integer
#  stakes_winning_foals_count       :integer
#  stillborn_foals_count            :integer
#  total_foal_earnings              :bigint
#  total_foal_points                :integer
#  total_foal_races                 :integer
#  unborn_foals_count               :integer
#  winning_foals_count              :integer
#  horse_id                         :bigint           primary key, uniquely indexed
#
# Indexes
#
#  index_stud_foal_records_on_horse_id  (horse_id) UNIQUE
#

