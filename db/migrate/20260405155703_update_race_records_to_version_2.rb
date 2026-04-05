class UpdateRaceRecordsToVersion2 < ActiveRecord::Migration[8.1]
  def change
    drop_view :annual_race_records, materialized: true
    drop_view :race_qualifications, materialized: true
    drop_view :lifetime_race_records, materialized: true
    drop_view :surface_race_records
    update_view :race_records,
      version: 2,
      revert_to_version: 1,
      materialized: { side_by_side: true }
  end
end

