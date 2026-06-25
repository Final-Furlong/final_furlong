module Racing::Qualifications
  class BreedersCupJuvenileTurfFilly < ApplicationRecord
    include BreedersCupQualifiable

    self.table_name = "breeders_cup_juvenile_turf_fillies_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse::Racehorse", inverse_of: :breeders_cup_juvenile_turf_fillies_qualification
  end
end

# == Schema Information
#
# Table name: breeders_cup_juvenile_turf_fillies_qualifiers
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
#  idx_on_allowance_wins_6958126666                               (allowance_wins)
#  idx_on_horse_id_a722cf4d93                                     (horse_id) UNIQUE
#  idx_on_nominated_77d0ced509                                    (nominated)
#  idx_on_stakes_seconds_de1a16769d                               (stakes_seconds)
#  idx_on_stakes_thirds_4520661d16                                (stakes_thirds)
#  idx_on_stakes_wins_92826ef8fb                                  (stakes_wins)
#  index_breeders_cup_juvenile_turf_fillies_qualifiers_on_points  (points)
#
