module Racing::Qualifications
  class BreedersSeriesFilliesSteeplechase < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_steeplechase_fillies_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_series_filly_steeplechase_qualification
  end
end

# == Schema Information
#
# Table name: breeders_series_steeplechase_fillies_qualifiers
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
#  idx_on_allowance_wins_8d662409bb  (allowance_wins)
#  idx_on_horse_id_7ef0f30f1f        (horse_id) UNIQUE
#  idx_on_points_2934513348          (points)
#  idx_on_stakes_seconds_34046d50e5  (stakes_seconds)
#  idx_on_stakes_thirds_1c4b20c091   (stakes_thirds)
#  idx_on_stakes_wins_3bc5e8c702     (stakes_wins)
#

