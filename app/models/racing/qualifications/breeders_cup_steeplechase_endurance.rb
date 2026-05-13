module Racing::Qualifications
  class BreedersCupSteeplechaseEndurance < ApplicationRecord
    include BreedersCupQualifiable

    self.table_name = "breeders_cup_sc_endurance_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_cup_sc_endurance_qualification
  end
end

# == Schema Information
#
# Table name: breeders_cup_sc_endurance_qualifiers
# Database name: primary
#
#  allowance_wins :bigint
#  nominated      :boolean
#  points         :bigint
#  stakes_seconds :bigint
#  stakes_starts  :bigint
#  stakes_thirds  :bigint
#  stakes_wins    :bigint
#  starts         :bigint
#  horse_id       :bigint           primary key
#

