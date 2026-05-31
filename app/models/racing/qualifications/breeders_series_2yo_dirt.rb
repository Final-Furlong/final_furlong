module Racing::Qualifications
  class BreedersSeries2yoDirt < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_2yo_dirt_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_series_2yo_dirt_qualification
  end
end

# == Schema Information
#
# Table name: breeders_series_2yo_dirt_qualifiers
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

