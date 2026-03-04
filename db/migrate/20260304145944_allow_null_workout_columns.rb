class AllowNullWorkoutColumns < ActiveRecord::Migration[8.1]
  def change
    change_column_null :workouts, :activity1, true
    change_column_null :workouts, :activity2, true
    change_column_null :workouts, :activity3, true
    change_column_null :workouts, :activity1_time_in_seconds, true
    change_column_null :workouts, :activity2_time_in_seconds, true
    change_column_null :workouts, :activity3_time_in_seconds, true
    change_column_null :workouts, :distance1, true
    change_column_null :workouts, :distance2, true
    change_column_null :workouts, :distance3, true
  end
end

