module Racing::Qualifications
  class BreedersSeries2yoDirt < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_2yo_dirt_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_series_2yo_dirt_qualification
  end
end

# == Schema Information
#
# Table name: breeders_series_2yo_dirt_qualifiers
# Database name: primary
#
#  allowance_wins :bigint           indexed
#  points         :bigint           indexed
#  stakes_seconds :integer          indexed
#  stakes_starts  :integer
#  stakes_thirds  :integer          indexed
#  stakes_wins    :integer          indexed
#  starts         :integer
#  horse_id       :bigint           primary key, uniquely indexed
#
# Indexes
#
#  index_breeders_series_2yo_dirt_qualifiers_on_allowance_wins  (allowance_wins)
#  index_breeders_series_2yo_dirt_qualifiers_on_horse_id        (horse_id) UNIQUE
#  index_breeders_series_2yo_dirt_qualifiers_on_points          (points)
#  index_breeders_series_2yo_dirt_qualifiers_on_stakes_seconds  (stakes_seconds)
#  index_breeders_series_2yo_dirt_qualifiers_on_stakes_thirds   (stakes_thirds)
#  index_breeders_series_2yo_dirt_qualifiers_on_stakes_wins     (stakes_wins)
#

