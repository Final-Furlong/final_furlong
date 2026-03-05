class DeleteOldWorkoutColumns < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      remove_column :workouts, :rank, :integer, if_exists: true
      remove_column :workouts, :total_time_in_seconds, :integer, if_exists: true
      remove_column :workouts, :activity1, if_exists: true
      remove_column :workouts, :activity1_time_in_seconds, :integer, if_exists: true
      remove_column :workouts, :distance1, :integer, if_exists: true
      remove_column :workouts, :activity2, if_exists: true
      remove_column :workouts, :activity2_time_in_seconds, :integer, if_exists: true
      remove_column :workouts, :distance2, :integer, if_exists: true
      remove_column :workouts, :activity3, if_exists: true
      remove_column :workouts, :activity3_time_in_seconds, :integer, if_exists: true
      remove_column :workouts, :distance3, :integer, if_exists: true
    end
  end
end

