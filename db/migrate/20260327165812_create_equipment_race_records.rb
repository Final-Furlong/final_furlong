class CreateEquipmentRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :equipment_race_records
  end
end

