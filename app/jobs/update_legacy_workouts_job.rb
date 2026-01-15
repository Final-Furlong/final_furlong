class UpdateLegacyWorkoutsJob < ApplicationJob
  queue_as :low_priority

  def perform
    workouts = 0
    Legacy::Workout.unscoped.find_each do |workout|
      if Racing::Workout.joins(:horse).where(horse: { legacy_id: workout.Horse }).exists?(date: workout.Date - 4.years)
        workout.destroy
        next
      end

      UpdateLegacyWorkoutJob.perform_later(workout.ID)
      workouts += 1
    end
    store_job_info(outcome: { workouts: })
  end
end

