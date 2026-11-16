class CreateBreedersSeriesStableStandings < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_series_stable_standings
  end
end

