class Workouts::UpdateStatsJob < ApplicationJob
  queue_as :low_priority

  def perform
    activities = %w[walk jog canter gallop breeze]
    Horses::Horse.racehorse.where.missing(:workout_stats).where.associated(:workouts).distinct.find_each do |horse|
      activities.each do |activity|
        best_workout = Workouts::Workout.where(horse:).joins(:activities)
          .merge(Workouts::Activity.by_activity(activity).with_time)
          .order(Arel.sql("(workout_activities.time_in_seconds::decimal / workout_activities.distance) ASC"))
          .first
        next unless best_workout

        stat = Workouts::Stat.find_or_initialize_by(horse:, activity:)
        best_activity = best_workout.activities.find { |act| act.activity == activity }
        stat.best_time_in_seconds = best_activity.time_in_seconds.fdiv(best_activity.distance)
        stat.best_date = best_workout.date
        recent_workout = Workouts::Workout.where(horse:).joins(:activities)
          .merge(Workouts::Activity.by_activity(activity).with_time)
          .order("workouts.date ASC")
          .last
        recent_activity = recent_workout.activities.find { |act| act.activity == activity }
        stat.recent_time_in_seconds = recent_activity.time_in_seconds.fdiv(recent_activity.distance)
        stat.recent_date = recent_workout.date
        stat.save!
      end
    end
  end
end

