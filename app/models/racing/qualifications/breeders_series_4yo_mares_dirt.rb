module Racing::Qualifications
  class BreedersSeries4yoMaresDirt < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_4yo_mares_dirt_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse::Racehorse", inverse_of: :breeders_series_4yo_mare_dirt_qualification
  end
end

# == Schema Information
#
# Table name: breeders_series_4yo_mares_dirt_qualifiers
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
#  idx_on_allowance_wins_15a9825669                                (allowance_wins)
#  idx_on_stakes_seconds_0ec6025c16                                (stakes_seconds)
#  idx_on_stakes_thirds_600f84fe5d                                 (stakes_thirds)
#  index_breeders_series_4yo_mares_dirt_qualifiers_on_horse_id     (horse_id) UNIQUE
#  index_breeders_series_4yo_mares_dirt_qualifiers_on_points       (points)
#  index_breeders_series_4yo_mares_dirt_qualifiers_on_stakes_wins  (stakes_wins)
#

