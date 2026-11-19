class AddNotNullForBreedersSeriesPotentialEntries < ActiveRecord::Migration[8.1]
  def change
    change_column_null :breeders_series_potential_entries, :first_race_id, false
    change_column_null :breeders_series_potential_entries, :second_race_id, false
    change_column_null :breeders_series_potential_entries, :third_race_id, false
  end
end

