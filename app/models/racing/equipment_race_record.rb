module Racing
  class EquipmentRaceRecord < ApplicationRecord
    include Equipmentable

    self.table_name = "equipment_race_records"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :equipment_race_records

    def self.populated?
      Scenic.database.populated?(table_name)
    end

    def readonly?
      true
    end

    def starts_string
      stakes_string(starts, stakes_starts)
    end

    def wins_string
      stakes_string(wins, stakes_wins)
    end

    def seconds_string
      stakes_string(seconds, stakes_seconds)
    end

    def thirds_string
      stakes_string(thirds, stakes_thirds)
    end

    def fourths_string
      stakes_string(fourths, stakes_fourths)
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
# Table name: equipment_race_records
# Database name: primary
#
#  equipment      :integer
#  fourths        :bigint
#  seconds        :bigint
#  stakes_fourths :bigint
#  stakes_seconds :bigint
#  stakes_starts  :bigint
#  stakes_thirds  :bigint
#  stakes_wins    :bigint
#  starts         :bigint
#  thirds         :bigint
#  wins           :bigint
#  horse_id       :bigint           primary key
#

