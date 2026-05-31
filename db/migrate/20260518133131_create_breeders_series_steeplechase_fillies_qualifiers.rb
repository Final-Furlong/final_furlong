class CreateBreedersSeriesSteeplechaseFilliesQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_series_steeplechase_fillies_qualifiers
  end
end

