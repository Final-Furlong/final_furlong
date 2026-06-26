module Racing::Qualifications
  class BreedersCupFillyAndMareSprint < ApplicationRecord
    include BreedersCupQualifiable

    self.table_name = "breeders_cup_filly_mare_sprint_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse::Racehorse", inverse_of: :breeders_cup_filly_and_mare_sprint_qualification
  end
end

# == Schema Information
#
# Table name: breeders_cup_filly_mare_sprint_qualifiers
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
#  idx_on_allowance_wins_1da02d1708                                (allowance_wins)
#  idx_on_stakes_seconds_4ff9d665e1                                (stakes_seconds)
#  idx_on_stakes_thirds_fefe5194f9                                 (stakes_thirds)
#  index_breeders_cup_filly_mare_sprint_qualifiers_on_horse_id     (horse_id) UNIQUE
#  index_breeders_cup_filly_mare_sprint_qualifiers_on_nominated    (nominated)
#  index_breeders_cup_filly_mare_sprint_qualifiers_on_points       (points)
#  index_breeders_cup_filly_mare_sprint_qualifiers_on_stakes_wins  (stakes_wins)
#

