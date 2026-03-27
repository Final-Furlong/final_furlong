class UpdateLocationRaceRecordsToVersion2 < ActiveRecord::Migration[8.1]
  def change
    update_view :location_race_records, version: 2, revert_to_version: 1
  end
end

