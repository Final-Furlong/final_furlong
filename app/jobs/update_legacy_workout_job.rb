class UpdateLegacyWorkoutJob < ApplicationJob
  queue_as :low_priority

  discard_on ActiveRecord::RecordInvalid

  def perform(workout_id)
    legacy_workout = Legacy::Workout.find(workout_id)
    horse = Horses::Horse.find_by!(legacy_id: legacy_workout.Horse)
    return unless horse.racehorse?

    migrate_workout(horse:, legacy_workout:)
  end

  private

  def migrate_workout(horse:, legacy_workout:)
    date = legacy_workout.Date - 4.years
    legacy_track = Legacy::Racetrack.find_by(ID: legacy_workout.Location)
    return unless legacy_track

    racetrack = Racing::Racetrack.find_by(name: legacy_track.Name)
    return unless racetrack

    jockey = Racing::Jockey.find_by(legacy_id: legacy_workout.Jockey)
    Racing::Workout.find_or_initialize_by(horse:, date:)
    Workouts::LegacyWorkoutCreator.new.create_workout(
      date:,
      horse:,
      racetrack:,
      jockey:,
      surface: (legacy_workout.DTSC == 1) ? "dirt" : "turf",
      legacy_condition: legacy_workout.Condition,
      legacy_activity1: legacy_workout.Activity1,
      distance1: legacy_workout.Distance1,
      legacy_activity2: legacy_workout.Activity2,
      distance2: legacy_workout.Distance2,
      legacy_activity3: legacy_workout.Activity3,
      distance3: legacy_workout.Distance3,
      confidence: legacy_workout.confidence,
      effort: legacy_workout.Effort,
      legacy_equipment: legacy_workout.Equipment,
      legacy_comment: legacy_workout.Comment
    )
  end
end

