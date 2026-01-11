class UpdateLegacyWorkoutsJob < ApplicationJob
  queue_as :low_priority

  def perform
    workouts = 0
    min_date = (Racing::Workout.maximum(:date) || Date.current - 30.years) + 4.years
    Legacy::Workout.unscoped.joins(:horse).where("Date > ?", min_date).where(horse: { Status: 3 }).order(Date: :asc).find_each do |workout|
      next if Racing::Workout.joins(:horse).where(horse: { legacy_id: workout.Horse }).exists?(date: workout.Date - 4.years)

      UpdateLegacyWorkoutJob.perform_later(workout.ID)
      workouts += 1
    end
    store_job_info(outcome: { workouts: })
  end
end

