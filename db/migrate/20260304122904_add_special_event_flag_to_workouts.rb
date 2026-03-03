class AddSpecialEventFlagToWorkouts < ActiveRecord::Migration[8.1]
  def change
    add_column :workouts, :special_event, :boolean, default: false, null: false
    add_index :workouts, :special_event
  end
end

