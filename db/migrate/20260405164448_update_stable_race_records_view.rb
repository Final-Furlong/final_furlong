class UpdateStableRaceRecordsView < ActiveRecord::Migration[8.1]
  def change
    drop_view :stable_annual_race_records, materialized: true
    update_view :stable_race_records,
      version: 2,
      revert_to_version: 1,
      materialized: { side_by_side: true }
  end
end

