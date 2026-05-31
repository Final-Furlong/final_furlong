module Racing::Qualifications
  class BreedersSeries3yoFilliesDirt < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_3yo_dirt_fillies_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_series_3yo_filly_dirt_qualification
  end
end

