module Racing::Qualifications
  class BreedersSeries3yoFilliesDirt < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_3yo_fillies_dirt_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_series_3yo_filly_dirt_qualification
  end
end

# == Schema Information
#
# Table name: breeders_series_3yo_fillies_dirt_qualifiers
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
#  idx_on_allowance_wins_e3d463a019                               (allowance_wins)
#  idx_on_stakes_seconds_d59d9793ed                               (stakes_seconds)
#  idx_on_stakes_thirds_699277faa6                                (stakes_thirds)
#  idx_on_stakes_wins_65cceac31f                                  (stakes_wins)
#  index_breeders_series_3yo_fillies_dirt_qualifiers_on_horse_id  (horse_id) UNIQUE
#  index_breeders_series_3yo_fillies_dirt_qualifiers_on_points    (points)
#

