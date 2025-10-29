class CreateAnnualRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :annual_race_records, materialized: true
  end
end

