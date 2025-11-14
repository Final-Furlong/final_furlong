module Horses
  class StudFoalRecord < ApplicationRecord
    self.table_name = "stud_foal_records"

    belongs_to :stud, class_name: "Horse", foreign_key: :horse_id, inverse_of: :stud_foal_record

    validates :crops_count, :born_foals_count, :stillborn_foals_count, :unborn_foals_count,
      :raced_foals_count, :winning_foals_count, :stakes_winning_foals_count,
      :multi_stakes_winning_foals_count, :millionaire_foals_count,
      :multi_millionaire_foals_count, :total_foal_earnings,
      :total_foal_races, :total_foal_points, presence: true
    validates :crops_count, :born_foals_count, :stillborn_foals_count, :unborn_foals_count,
      :raced_foals_count, :winning_foals_count, :stakes_winning_foals_count,
      :multi_stakes_winning_foals_count, :millionaire_foals_count,
      :multi_millionaire_foals_count, :total_foal_earnings,
      :total_foal_races, :total_foal_points,
      numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :stillborn_foals_count, comparison: { less_than_or_equal_to: :born_foals_count }
    validates :raced_foals_count, comparison: { less_than_or_equal_to: :born_foals_count }
    validates :winning_foals_count, comparison: { less_than_or_equal_to: :raced_foals_count }
    validates :stakes_winning_foals_count, comparison: { less_than_or_equal_to: :winning_foals_count }
    validates :multi_stakes_winning_foals_count, comparison: { less_than_or_equal_to: :stakes_winning_foals_count }
    validates :millionaire_foals_count, comparison: { less_than_or_equal_to: :raced_foals_count }
    validates :multi_millionaire_foals_count, comparison: { less_than_or_equal_to: :millionaire_foals_count }

    def breed_ranking_string
      return I18n.t("common.none") if breed_ranking.blank?

      "#{breed_ranking.titleize} (#{total_foal_points.fdiv(total_foal_races).round(1)})"
    end

    def living_foals_count
      born_foals_count - stillborn_foals_count
    end

    def living_foals_string
      value = living_foals_count.to_s
      if crops_count.positive?
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
# Table name: stud_foal_records
# Database name: primary
#
#  id                               :bigint           not null, primary key
#  born_foals_count                 :integer          default(0), not null, indexed
#  breed_ranking                    :string
#  crops_count                      :integer          default(0), not null
#  millionaire_foals_count          :integer          default(0), not null
#  multi_millionaire_foals_count    :integer          default(0), not null
#  multi_stakes_winning_foals_count :integer          default(0), not null
#  raced_foals_count                :integer          default(0), not null
#  stakes_winning_foals_count       :integer          default(0), not null
#  stillborn_foals_count            :integer          default(0), not null
#  total_foal_earnings              :bigint           default(0), not null
#  total_foal_points                :integer          default(0), not null
#  total_foal_races                 :integer          default(0), not null
#  unborn_foals_count               :integer          default(0), not null
#  winning_foals_count              :integer          default(0), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  horse_id                         :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_stud_foal_records_on_born_foals_count  (born_foals_count)
#  index_stud_foal_records_on_horse_id          (horse_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

