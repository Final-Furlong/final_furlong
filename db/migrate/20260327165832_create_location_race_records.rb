class CreateLocationRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :location_race_records
  end
end

