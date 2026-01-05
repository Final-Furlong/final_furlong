class UpdateLegacyWorkoutsJob < ApplicationJob
  queue_as :low_priority

  def perform
    legacy_id = Rails.cache.fetch("workout_migration_legacy_horse_id") { Horses::Horse.racehorse.minimum(:legacy_id) }
    horse = Horses::Horse.racehorse.find_by(legacy_id:)
    schedule_next_workout_job(legacy_id:, wait: 0) and return unless horse

    max_date = Legacy::Workout.unscoped.where(Horse: legacy_id).maximum(:date)
    schedule_next_workout_job(legacy_id:, wait: 0) and return unless max_date

    min_date = max_date - 6.months
    Legacy::Workout.unscoped.where(Horse: legacy_id).where("Date > ?", min_date).order(Date: :asc).find_each do |workout|
      next if Racing::Workout.exists?(horse:, date: workout.Date - 4.years)

      UpdateLegacyWorkoutJob.perform_later(workout.ID)
    end
    schedule_next_workout_job(legacy_id:)
    store_job_info(outcome: { legacy_id: })
  end

  private

  def schedule_next_workout_job(legacy_id:, wait: 2)
    return unless Horses::Horse.racehorse.where("legacy_id > ?", legacy_id).where.missing(:workouts).exists?

    next_id = Horses::Horse.racehorse.where("legacy_id > ?", legacy_id).where.missing(:workouts).minimum(:legacy_id)
    Rails.cache.write("workout_migration_legacy_horse_id", next_id, expires_in: 2.days)

    UpdateLegacyWorkoutsJob.set(wait: wait.minutes).perform_later
  end
end

