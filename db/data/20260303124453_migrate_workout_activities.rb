# frozen_string_literal: true

class MigrateWorkoutActivities < ActiveRecord::Migration[8.1]
  def up
    Workouts::Workout.where.missing(:activities).find_each do |workout|
      ActiveRecord::Base.transaction do
        save_activity(workout, 1)
        save_activity(workout, 2)
        save_activity(workout, 3)
      end
    end
  end

  def save_activity(workout, index)
    workout_activity = workout.send(:"activity#{index}")
    return if workout_activity.blank?

    activity = Workouts::Activity.find_or_initialize_by(workout_id: workout.id, activity: workout_activity)
    activity.distance = workout.send(:"distance#{index}")
    activity.activity_index = index
    time_in_seconds = workout.send(:"activity#{index}_time_in_seconds")
    activity.time_in_seconds = time_in_seconds if time_in_seconds.to_i.positive?
    activity.save! if activity.valid?
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

