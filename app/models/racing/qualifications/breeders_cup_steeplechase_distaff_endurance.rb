module Racing::Qualifications
  class BreedersCupSteeplechaseDistaffEndurance < ApplicationRecord
    include BreedersCupQualifiable

    self.table_name = "breeders_cup_sc_distaff_endurance_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_cup_sc_distaff_endurance_qualification
  end
end

# == Schema Information
#
# Table name: breeders_cup_sc_distaff_endurance_qualifiers
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
#  horse_id       :bigint           primary key, indexed
#
# Indexes
#
#  idx_on_allowance_wins_fb35a643e9                                (allowance_wins)
#  idx_on_nominated_fcdcc60603                                     (nominated)
#  idx_on_stakes_seconds_a7fdb3416e                                (stakes_seconds)
#  idx_on_stakes_thirds_3e561673d4                                 (stakes_thirds)
#  idx_on_stakes_wins_147dde5f62                                   (stakes_wins)
#  index_breeders_cup_sc_distaff_endurance_qualifiers_on_horse_id  (horse_id)
#  index_breeders_cup_sc_distaff_endurance_qualifiers_on_points    (points)
#

