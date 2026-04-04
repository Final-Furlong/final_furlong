class CreateStableRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :stable_race_records, materialized: true
  end
end

