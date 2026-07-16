class UpdateBreedersSeriesSteeplechaseFilliesQualifiersToVersion2 < ActiveRecord::Migration[8.1]
  def change
    update_view :breeders_series_steeplechase_fillies_qualifiers,
      version: 2,
      revert_to_version: 1,
      materialized: { side_by_side: true }
  end
end

