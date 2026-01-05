class UpdateLegacyWorkoutJob < ApplicationJob
  queue_as :low_priority

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

    workout = Racing::Workout.find_or_initialize_by(horse:, date:)
    workout.jockey = Racing::Jockey.find_by(legacy_id: legacy_workout.Jockey)
    workout.racetrack = racetrack
    workout.location = racetrack.location
    workout.surface = racetrack.surfaces.find_by(surface: (legacy_workout.DTSC == 1) ? "dirt" : "turf")
    workout.condition = find_condition(legacy_workout.Condition)
    workout.activity1 = find_activity(legacy_workout.Activity1)
    workout.distance1 = legacy_workout.Distance1
    if legacy_workout.Activity2.to_i.positive?
      workout.activity2 = find_activity(legacy_workout.Activity2)
      workout.distance2 = legacy_workout.Distance2
    end
    if legacy_workout.Activity3.to_i.positive?
      workout.activity3 = find_activity(legacy_workout.Activity3)
      workout.distance3 = legacy_workout.Distance3
    end
    workout.confidence = legacy_workout.confidence
    workout.effort = legacy_workout.Effort
    workout.blinkers = has_equipment(legacy_workout.Equipment, :blinkers)
    workout.shadow_roll = has_equipment(legacy_workout.Equipment, :shadow_roll)
    workout.wraps = has_equipment(legacy_workout.Equipment, :wraps)
    workout.figure_8 = has_equipment(legacy_workout.Equipment, :figure_8)
    workout.no_whip = has_equipment(legacy_workout.Equipment, :no_whip)
    workout.comment = find_comment(legacy_workout.Comment)
    workout.save!
  end

  def find_comment(id)
    line = Legacy::JockeyLine.find_by!(ID: id)
    i18n_key = line.Stat.downcase
    i18n_key = "natural_energy" if i18n_key == "natenergy"
    if line.Value.present?
      i18n_key += line.Value.to_i.negative? ? "_negative" : "_#{line.Value}"
    end
    Racing::WorkoutComment.find_by!(comment_i18n_key: i18n_key)
  end

  def has_equipment(id, type)
    return 0 if id.blank? || id.zero?

    legacy_equipment = Legacy::Equipment.find(id).Equipment.split(" ")
    case type
    when :blinkers
      legacy_equipment.include?("B")
    when :shadow_roll
      legacy_equipment.include?("SR")
    when :wraps
      legacy_equipment.include?("W")
    when :figure_8
      legacy_equipment.include?("F8")
    when :no_whip
      legacy_equipment.include?("NW")
    end
  end

  def find_condition(id)
    case id
    when 1, 2 then "fast"
    when 3, 4 then "good"
    when 5, 6 then "wet"
    when 7, 8 then "slow"
    end
  end

  def find_activity(id)
    case id
    when 1 then "walk"
    when 2 then "jog"
    when 3 then "canter"
    when 4 then "gallop"
    when 5 then "breeze"
    end
  end
end

