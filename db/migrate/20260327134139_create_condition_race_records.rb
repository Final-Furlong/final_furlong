class CreateConditionRaceRecords < ActiveRecord::Migration[8.1]
  def change
    create_view :condition_race_records
  end
end

