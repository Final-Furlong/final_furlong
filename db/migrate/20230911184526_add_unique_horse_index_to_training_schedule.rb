class AddUniqueHorseIndexToTrainingSchedule < ActiveRecord::Migration[7.0]
  def change
    remove_index :training_schedules_horses, :horse_id

    add_index :training_schedules_horses, :horse_id, unique: true
  end
end

