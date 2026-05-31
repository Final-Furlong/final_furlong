module Racing::Qualifications
  class BreedersCupJuvenile < ApplicationRecord
    include BreedersCupQualifiable

    self.table_name = "breeders_cup_juvenile_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_cup_juvenile_qualification
  end
end

# == Schema Information
#
# Table name: breeders_cup_juvenile_qualifiers
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
#  index_breeders_cup_juvenile_qualifiers_on_allowance_wins  (allowance_wins)
#  index_breeders_cup_juvenile_qualifiers_on_horse_id        (horse_id) UNIQUE
#  index_breeders_cup_juvenile_qualifiers_on_nominated       (nominated)
#  index_breeders_cup_juvenile_qualifiers_on_points          (points)
#  index_breeders_cup_juvenile_qualifiers_on_stakes_seconds  (stakes_seconds)
#  index_breeders_cup_juvenile_qualifiers_on_stakes_thirds   (stakes_thirds)
#  index_breeders_cup_juvenile_qualifiers_on_stakes_wins     (stakes_wins)
#

