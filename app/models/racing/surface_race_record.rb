module Racing
  class SurfaceRaceRecord < ApplicationRecord
    self.table_name = "surface_race_records"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :surface_race_record

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
      value = basic.to_i.to_s
      value += "(#{stakes.to_i})" if stakes.to_i.positive?
      value
    end
  end
end

# == Schema Information
#
# Table name: surface_race_records
# Database name: primary
#
#  dirt_earnings       :decimal(, )
#  dirt_fourths        :decimal(, )
#  dirt_points         :decimal(, )
#  dirt_seconds        :decimal(, )
#  dirt_stakes_fourths :decimal(, )
#  dirt_stakes_seconds :decimal(, )
#  dirt_stakes_starts  :decimal(, )
#  dirt_stakes_thirds  :decimal(, )
#  dirt_stakes_wins    :decimal(, )
#  dirt_starts         :decimal(, )
#  dirt_thirds         :decimal(, )
#  dirt_wins           :decimal(, )
#  jump_earnings       :decimal(, )
#  jump_fourths        :decimal(, )
#  jump_points         :decimal(, )
#  jump_seconds        :decimal(, )
#  jump_stakes_fourths :decimal(, )
#  jump_stakes_seconds :decimal(, )
#  jump_stakes_starts  :decimal(, )
#  jump_stakes_thirds  :decimal(, )
#  jump_stakes_wins    :decimal(, )
#  jump_starts         :decimal(, )
#  jump_thirds         :decimal(, )
#  jump_wins           :decimal(, )
#  turf_earnings       :decimal(, )
#  turf_fourths        :decimal(, )
#  turf_points         :decimal(, )
#  turf_seconds        :decimal(, )
#  turf_stakes_fourths :decimal(, )
#  turf_stakes_seconds :decimal(, )
#  turf_stakes_starts  :decimal(, )
#  turf_stakes_thirds  :decimal(, )
#  turf_stakes_wins    :decimal(, )
#  turf_starts         :decimal(, )
#  turf_thirds         :decimal(, )
#  turf_wins           :decimal(, )
#  horse_id            :bigint           primary key
#

