class UpdateBroodmareFoalRecordsToVersion2 < ActiveRecord::Migration[8.1]
  def change
    update_view :broodmare_foal_records,
      version: 2,
      revert_to_version: 1,
      materialized: true
  end
end

