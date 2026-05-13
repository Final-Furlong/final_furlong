module Racing::Qualifications
  class BreedersCupJuvenileTurfFilly < ApplicationRecord
    include BreedersCupQualifiable

    self.table_name = "breeders_cup_juvenile_turf_fillies_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_cup_juvenile_turf_fillies_qualification
  end
end

# == Schema Information
#
# Table name: breeders_cup_juvenile_turf_fillies_qualifiers
# Database name: primary
#
#  allowance_wins :bigint
#  nominated      :boolean
#  points         :bigint
#  stakes_seconds :integer
#  stakes_starts  :integer
#  stakes_thirds  :integer
#  stakes_wins    :integer
#  starts         :integer
#  horse_id       :bigint           primary key
#

