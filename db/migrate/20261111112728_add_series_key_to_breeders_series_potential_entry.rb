class AddSeriesKeyToBreedersSeriesPotentialEntry < ActiveRecord::Migration[8.1]
  def change
    add_column :breeders_series_potential_entries, :series, :string
    add_index :breeders_series_potential_entries, %i[series horse_id], unique: true
  end
end

