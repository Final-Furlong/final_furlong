module Racing::Qualifications
  class BreedersSeries2yoFilliesTurf < ApplicationRecord
    include BreedersSeriesQualifiable

    self.table_name = "breeders_series_2yo_turf_fillies_qualifiers"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeders_series_2yo_filly_turf_qualification
  end
end

