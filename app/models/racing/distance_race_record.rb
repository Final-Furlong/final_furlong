module Racing
  class DistanceRaceRecord < ApplicationRecord
    self.table_name = "distance_race_records"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :distance_race_record

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
# Table name: distance_race_records
# Database name: primary
#
#  jump_long_fourths          :bigint
#  jump_long_seconds          :bigint
#  jump_long_stakes_fourths   :bigint
#  jump_long_stakes_seconds   :bigint
#  jump_long_stakes_starts    :bigint
#  jump_long_stakes_thirds    :bigint
#  jump_long_stakes_wins      :bigint
#  jump_long_starts           :bigint
#  jump_long_thirds           :bigint
#  jump_long_wins             :bigint
#  jump_mid_fourths           :bigint
#  jump_mid_seconds           :bigint
#  jump_mid_stakes_fourths    :bigint
#  jump_mid_stakes_seconds    :bigint
#  jump_mid_stakes_starts     :bigint
#  jump_mid_stakes_thirds     :bigint
#  jump_mid_stakes_wins       :bigint
#  jump_mid_starts            :bigint
#  jump_mid_thirds            :bigint
#  jump_mid_wins              :bigint
#  jump_sprint_fourths        :bigint
#  jump_sprint_seconds        :bigint
#  jump_sprint_stakes_fourths :bigint
#  jump_sprint_stakes_seconds :bigint
#  jump_sprint_stakes_starts  :bigint
#  jump_sprint_stakes_thirds  :bigint
#  jump_sprint_stakes_wins    :bigint
#  jump_sprint_starts         :bigint
#  jump_sprint_thirds         :bigint
#  jump_sprint_wins           :bigint
#  long_fourths               :bigint
#  long_seconds               :bigint
#  long_stakes_fourths        :bigint
#  long_stakes_seconds        :bigint
#  long_stakes_starts         :bigint
#  long_stakes_thirds         :bigint
#  long_stakes_wins           :bigint
#  long_starts                :bigint
#  long_thirds                :bigint
#  long_wins                  :bigint
#  mid_fourths                :bigint
#  mid_seconds                :bigint
#  mid_stakes_fourths         :bigint
#  mid_stakes_seconds         :bigint
#  mid_stakes_starts          :bigint
#  mid_stakes_thirds          :bigint
#  mid_stakes_wins            :bigint
#  mid_starts                 :bigint
#  mid_thirds                 :bigint
#  mid_wins                   :bigint
#  sprint_fourths             :bigint
#  sprint_seconds             :bigint
#  sprint_stakes_fourths      :bigint
#  sprint_stakes_seconds      :bigint
#  sprint_stakes_starts       :bigint
#  sprint_stakes_thirds       :bigint
#  sprint_stakes_wins         :bigint
#  sprint_starts              :bigint
#  sprint_thirds              :bigint
#  sprint_wins                :bigint
#  horse_id                   :bigint           primary key
#

