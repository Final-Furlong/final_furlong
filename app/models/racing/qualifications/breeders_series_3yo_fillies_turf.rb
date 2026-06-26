module Racing::Qualifications
  class BreedersSeries3yoFilliesTurf < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_3yo_fillies_turf_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse::Racehorse", inverse_of: :breeders_series_3yo_filly_turf_qualification
  end
end

# == Schema Information
#
# Table name: breeders_series_3yo_fillies_turf_qualifiers
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
#  idx_on_allowance_wins_de83206749                               (allowance_wins)
#  idx_on_stakes_seconds_6299b20d76                               (stakes_seconds)
#  idx_on_stakes_thirds_747aae2a58                                (stakes_thirds)
#  idx_on_stakes_wins_177682cbbf                                  (stakes_wins)
#  index_breeders_series_3yo_fillies_turf_qualifiers_on_horse_id  (horse_id) UNIQUE
#  index_breeders_series_3yo_fillies_turf_qualifiers_on_points    (points)
#

