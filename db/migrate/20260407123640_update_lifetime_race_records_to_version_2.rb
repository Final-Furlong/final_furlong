class UpdateLifetimeRaceRecordsToVersion2 < ActiveRecord::Migration[8.1]
  def change
    drop_view :race_qualifications, materialized: true
    update_view :lifetime_race_records,
      version: 2,
      revert_to_version: 1,
      materialized: { side_by_side: true }
    create_view :race_qualifications, materialized: true
  end
end

