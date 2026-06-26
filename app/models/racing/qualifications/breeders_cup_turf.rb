module Racing::Qualifications
  class BreedersCupTurf < ApplicationRecord
    include BreedersCupQualifiable

    self.table_name = "breeders_cup_turf_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse::Racehorse", inverse_of: :breeders_cup_turf_qualification
  end
end

# == Schema Information
#
# Table name: breeders_cup_turf_qualifiers
# Database name: primary
#
#  allowance_wins :bigint           indexed
#  nominated      :boolean          indexed
#  points         :bigint           indexed
#  stakes_seconds :bigint           indexed
#  stakes_starts  :bigint
#  stakes_thirds  :bigint           indexed
#  stakes_wins    :bigint           indexed
#  starts         :bigint
#  horse_id       :bigint           primary key, uniquely indexed
#
# Indexes
#
#  index_breeders_cup_turf_qualifiers_on_allowance_wins  (allowance_wins)
#  index_breeders_cup_turf_qualifiers_on_horse_id        (horse_id) UNIQUE
#  index_breeders_cup_turf_qualifiers_on_nominated       (nominated)
#  index_breeders_cup_turf_qualifiers_on_points          (points)
#  index_breeders_cup_turf_qualifiers_on_stakes_seconds  (stakes_seconds)
#  index_breeders_cup_turf_qualifiers_on_stakes_thirds   (stakes_thirds)
#  index_breeders_cup_turf_qualifiers_on_stakes_wins     (stakes_wins)
#

