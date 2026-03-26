class CreateDistanceRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :distance_race_records
  end
end

