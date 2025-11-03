module Horses
  class BroodmareFoalRecord < ApplicationRecord
    self.table_name = "broodmare_foal_records"

    belongs_to :mare, class_name: "Horse", foreign_key: :horse_id, inverse_of: :broodmare_foal_record

    validates :born_foals_count, :stillborn_foals_count, :unborn_foals_count,
      :raced_foals_count, :winning_foals_count, :stakes_winning_foals_count,
      :multi_stakes_winning_foals_count, :millionaire_foals_count,
      :multi_millionaire_foals_count, :total_foal_earnings,
      :total_foal_races, :total_foal_points, presence: true
    validates :born_foals_count, :stillborn_foals_count, :unborn_foals_count,
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
      ActiveSupport::NumberHelper.number_to_currency(earnings, unit: "$", precision: 0)
    end

    private

    def string_with_percent(value, base_value)
      if value.positive?
        Rails.logger.info "value: #{value}, base: #{base_value}, #{value / base_value}"
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
#
#  id                               :bigint           not null, primary key
#  born_foals_count                 :integer          default(0), not null, indexed
#  breed_ranking                    :string           indexed
#  millionaire_foals_count          :integer          default(0), not null, indexed
#  multi_millionaire_foals_count    :integer          default(0), not null, indexed
#  multi_stakes_winning_foals_count :integer          default(0), not null, indexed
#  raced_foals_count                :integer          default(0), not null, indexed
#  stakes_winning_foals_count       :integer          default(0), not null, indexed
#  stillborn_foals_count            :integer          default(0), not null, indexed
#  total_foal_earnings              :bigint           default(0), not null
#  total_foal_points                :integer          default(0), not null, indexed
#  total_foal_races                 :integer          default(0), not null, indexed
#  unborn_foals_count               :integer          default(0), not null, indexed
#  winning_foals_count              :integer          default(0), not null, indexed
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  horse_id                         :bigint           not null, uniquely indexed
#
# Indexes
#
#  idx_on_multi_stakes_winning_foals_count_d86a3500a8             (multi_stakes_winning_foals_count)
#  index_broodmare_foal_records_on_born_foals_count               (born_foals_count)
#  index_broodmare_foal_records_on_breed_ranking                  (breed_ranking)
#  index_broodmare_foal_records_on_horse_id                       (horse_id) UNIQUE
#  index_broodmare_foal_records_on_millionaire_foals_count        (millionaire_foals_count)
#  index_broodmare_foal_records_on_multi_millionaire_foals_count  (multi_millionaire_foals_count)
#  index_broodmare_foal_records_on_old_id                         (old_id)
#  index_broodmare_foal_records_on_raced_foals_count              (raced_foals_count)
#  index_broodmare_foal_records_on_stakes_winning_foals_count     (stakes_winning_foals_count)
#  index_broodmare_foal_records_on_stillborn_foals_count          (stillborn_foals_count)
#  index_broodmare_foal_records_on_total_foal_points              (total_foal_points)
#  index_broodmare_foal_records_on_total_foal_races               (total_foal_races)
#  index_broodmare_foal_records_on_unborn_foals_count             (unborn_foals_count)
#  index_broodmare_foal_records_on_winning_foals_count            (winning_foals_count)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

