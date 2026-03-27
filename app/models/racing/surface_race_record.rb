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
      value = basic.to_s
      value += "(#{stakes})" if stakes.positive?
      value
    end
  end
end

# == Schema Information
#
# Table name: surface_race_records
# Database name: primary
#
#  dirt_fourths        :bigint
#  dirt_seconds        :bigint
#  dirt_stakes_fourths :bigint
#  dirt_stakes_seconds :bigint
#  dirt_stakes_starts  :bigint
#  dirt_stakes_thirds  :bigint
#  dirt_stakes_wins    :bigint
#  dirt_starts         :bigint
#  dirt_thirds         :bigint
#  dirt_wins           :bigint
#  jump_fourths        :bigint
#  jump_seconds        :bigint
#  jump_stakes_fourths :bigint
#  jump_stakes_seconds :bigint
#  jump_stakes_starts  :bigint
#  jump_stakes_thirds  :bigint
#  jump_stakes_wins    :bigint
#  jump_starts         :bigint
#  jump_thirds         :bigint
#  jump_wins           :bigint
#  turf_fourths        :bigint
#  turf_seconds        :bigint
#  turf_stakes_fourths :bigint
#  turf_stakes_seconds :bigint
#  turf_stakes_starts  :bigint
#  turf_stakes_thirds  :bigint
#  turf_stakes_wins    :bigint
#  turf_starts         :bigint
#  turf_thirds         :bigint
#  turf_wins           :bigint
#  horse_id            :bigint           primary key
#

