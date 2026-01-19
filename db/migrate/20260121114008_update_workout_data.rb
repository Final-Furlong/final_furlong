class UpdateWorkoutData < ActiveRecord::Migration[8.1]
  def change
    add_column :workouts, :total_time_in_seconds, :integer, default: 0
    add_index :workouts, :total_time_in_seconds
    add_column :workouts, :activity1_time_in_seconds, :integer, default: 0
    add_index :workouts, :activity1_time_in_seconds
    add_column :workouts, :activity2_time_in_seconds, :integer, default: 0
    add_index :workouts, :activity2_time_in_seconds
    add_column :workouts, :activity3_time_in_seconds, :integer, default: 0
    add_index :workouts, :activity3_time_in_seconds
  end
end

