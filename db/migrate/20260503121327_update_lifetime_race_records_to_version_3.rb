class UpdateLifetimeRaceRecordsToVersion3 < ActiveRecord::Migration[8.1]
  def change
    drop_view :race_qualifications, materialized: true
    update_view :lifetime_race_records,
      version: 3,
      revert_to_version: 2,
      materialized: { side_by_side: true }
    create_view :race_qualifications, materialized: true
  end
end

