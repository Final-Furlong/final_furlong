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
#  dirt_earnings       :bigint
#  dirt_fourths        :integer
#  dirt_points         :bigint
#  dirt_seconds        :integer
#  dirt_stakes_fourths :integer
#  dirt_stakes_seconds :integer
#  dirt_stakes_starts  :integer
#  dirt_stakes_thirds  :integer
#  dirt_stakes_wins    :integer
#  dirt_starts         :integer
#  dirt_thirds         :integer
#  dirt_wins           :integer
#  jump_earnings       :bigint
#  jump_fourths        :integer
#  jump_points         :bigint
#  jump_seconds        :integer
#  jump_stakes_fourths :integer
#  jump_stakes_seconds :integer
#  jump_stakes_starts  :integer
#  jump_stakes_thirds  :integer
#  jump_stakes_wins    :integer
#  jump_starts         :integer
#  jump_thirds         :integer
#  jump_wins           :integer
#  turf_earnings       :bigint
#  turf_fourths        :integer
#  turf_points         :bigint
#  turf_seconds        :integer
#  turf_stakes_fourths :integer
#  turf_stakes_seconds :integer
#  turf_stakes_starts  :integer
#  turf_stakes_thirds  :integer
#  turf_stakes_wins    :integer
#  turf_starts         :integer
#  turf_thirds         :integer
#  turf_wins           :integer
#  horse_id            :bigint           primary key
#

