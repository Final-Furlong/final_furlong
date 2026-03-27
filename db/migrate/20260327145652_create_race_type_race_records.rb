class CreateRaceTypeRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :race_type_race_records
  end
end

