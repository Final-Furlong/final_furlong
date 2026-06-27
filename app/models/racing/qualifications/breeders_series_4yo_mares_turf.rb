module Racing::Qualifications
  class BreedersSeries4yoMaresTurf < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_4yo_mares_turf_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse::Racehorse", inverse_of: :breeders_series_4yo_mare_turf_qualification
  end
end

# == Schema Information
#
# Table name: breeders_series_4yo_mares_turf_qualifiers
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
#  idx_on_allowance_wins_c2226437e5                                (allowance_wins)
#  idx_on_stakes_seconds_9cb5baa0c6                                (stakes_seconds)
#  idx_on_stakes_thirds_c61aeef92d                                 (stakes_thirds)
#  index_breeders_series_4yo_mares_turf_qualifiers_on_horse_id     (horse_id) UNIQUE
#  index_breeders_series_4yo_mares_turf_qualifiers_on_points       (points)
#  index_breeders_series_4yo_mares_turf_qualifiers_on_stakes_wins  (stakes_wins)
#

