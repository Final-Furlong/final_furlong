module Racing
  class ConditionRaceRecord < ApplicationRecord
    self.table_name = "condition_race_records"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :condition_race_record

    def self.populated?
      Scenic.database.populated?(table_name)
    end

    def readonly?
      true
    end

    def starts_string(prefix: "")
      stakes_string(send("#{prefix}_starts"), send("#{prefix}_stakes_starts"))
    end

    def wins_string(prefix: "")
      stakes_string(send("#{prefix}_wins"), send("#{prefix}_stakes_wins"))
    end

    def seconds_string(prefix: "")
      stakes_string(send("#{prefix}_seconds"), send("#{prefix}_stakes_seconds"))
    end

    def thirds_string(prefix: "")
      stakes_string(send("#{prefix}_thirds"), send("#{prefix}_stakes_thirds"))
    end

    def fourths_string(prefix: "")
      stakes_string(send("#{prefix}_fourths"), send("#{prefix}_stakes_fourths"))
    end

    private

    def stakes_string(basic, stakes)
      value = basic.to_s
      value += "(#{stakes})" if stakes.positive?
      value
    end
  end
end

# == Schema Information
#
# Table name: condition_race_records
# Database name: primary
#
#  fast_fourths        :bigint
#  fast_seconds        :bigint
#  fast_stakes_fourths :bigint
#  fast_stakes_seconds :bigint
#  fast_stakes_starts  :bigint
#  fast_stakes_thirds  :bigint
#  fast_stakes_wins    :bigint
#  fast_starts         :bigint
#  fast_thirds         :bigint
#  fast_wins           :bigint
#  good_fourths        :bigint
#  good_seconds        :bigint
#  good_stakes_fourths :bigint
#  good_stakes_seconds :bigint
#  good_stakes_starts  :bigint
#  good_stakes_thirds  :bigint
#  good_stakes_wins    :bigint
#  good_starts         :bigint
#  good_thirds         :bigint
#  good_wins           :bigint
#  slow_fourths        :bigint
#  slow_seconds        :bigint
#  slow_stakes_fourths :bigint
#  slow_stakes_seconds :bigint
#  slow_stakes_starts  :bigint
#  slow_stakes_thirds  :bigint
#  slow_stakes_wins    :bigint
#  slow_starts         :bigint
#  slow_thirds         :bigint
#  slow_wins           :bigint
#  wet_fourths         :bigint
#  wet_seconds         :bigint
#  wet_stakes_fourths  :bigint
#  wet_stakes_seconds  :bigint
#  wet_stakes_starts   :bigint
#  wet_stakes_thirds   :bigint
#  wet_stakes_wins     :bigint
#  wet_starts          :bigint
#  wet_thirds          :bigint
#  wet_wins            :bigint
#  horse_id            :bigint           primary key
#

