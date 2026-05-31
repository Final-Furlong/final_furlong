module Racing::Qualifications
  class BreedersCupJuvenileFilly < ApplicationRecord
    include BreedersCupQualifiable

    self.table_name = "breeders_cup_juvenile_fillies_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_cup_juvenile_fillies_qualification
  end
end

# == Schema Information
#
# Table name: breeders_cup_juvenile_fillies_qualifiers
# Database name: primary
#
#  allowance_wins :bigint           indexed
#  nominated      :boolean          indexed
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
#  idx_on_allowance_wins_eae2332575                               (allowance_wins)
#  idx_on_stakes_seconds_baa304970e                               (stakes_seconds)
#  idx_on_stakes_thirds_06b1723b73                                (stakes_thirds)
#  index_breeders_cup_juvenile_fillies_qualifiers_on_horse_id     (horse_id) UNIQUE
#  index_breeders_cup_juvenile_fillies_qualifiers_on_nominated    (nominated)
#  index_breeders_cup_juvenile_fillies_qualifiers_on_points       (points)
#  index_breeders_cup_juvenile_fillies_qualifiers_on_stakes_wins  (stakes_wins)
#

