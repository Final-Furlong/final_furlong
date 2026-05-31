module Racing::Qualifications
  class BreedersSeriesSteeplechase < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_steeplechase_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_series_steeplechase_qualification
  end
end

# == Schema Information
#
# Table name: breeders_series_steeplechase_qualifiers
# Database name: primary
#
#  allowance_wins :bigint
#  points         :bigint
#  stakes_seconds :integer
#  stakes_starts  :integer
#  stakes_thirds  :integer
#  stakes_wins    :integer
#  starts         :integer
#  horse_id       :bigint           primary key
#

