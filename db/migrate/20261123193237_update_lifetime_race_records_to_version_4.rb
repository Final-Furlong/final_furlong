class UpdateLifetimeRaceRecordsToVersion4 < ActiveRecord::Migration[8.1]
  def change
    drop_view :race_qualifications, materialized: true
    drop_view :broodmare_foal_records, materialized: true
    drop_view :stud_foal_records, materialized: true
    update_view :lifetime_race_records,
      version: 4,
      revert_to_version: 3,
      materialized: { side_by_side: true }
    create_view :race_qualifications, version: 2, materialized: true
    create_view :broodmare_foal_records, version: 3, materialized: true
    create_view :stud_foal_records, version: 2, materialized: true
  end
end

