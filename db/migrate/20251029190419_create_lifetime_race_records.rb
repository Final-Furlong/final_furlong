class CreateLifetimeRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :lifetime_race_records, materialized: true
  end
end

