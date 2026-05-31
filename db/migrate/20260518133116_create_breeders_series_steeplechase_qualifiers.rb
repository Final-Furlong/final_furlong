class CreateBreedersSeriesSteeplechaseQualifiers < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_series_steeplechase_qualifiers
  end
end

