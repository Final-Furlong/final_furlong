module Workouts
  class LegacyWorkoutCreator
    def create_workout(date:, horse:, racetrack:, jockey:, surface:,
      legacy_condition:, legacy_activity1:, distance1:, confidence:,
      effort:, legacy_comment:, legacy_equipment: nil, legacy_activity2: nil,
      distance2: nil, legacy_activity3: nil, distance3: nil)
      workout = Racing::Workout.find_or_initialize_by(horse:, date:)
      workout.jockey = jockey
      workout.racetrack = racetrack
      workout.location = racetrack.location
      workout.surface = racetrack.surfaces.find_by(surface:)
      workout.condition = find_condition(legacy_condition)
      workout.activity1 = find_activity(legacy_activity1)
      workout.distance1 = distance1
      if legacy_activity2.present?
        workout.activity2 = find_activity(legacy_activity2)
        workout.distance2 = distance2
      end
      if legacy_activity3.present?
        workout.activity3 = find_activity(legacy_activity3)
        workout.distance3 = distance3
      end
      workout.confidence = confidence
      workout.effort = effort
      if legacy_equipment.present?
        workout.blinkers = has_equipment(legacy_equipment, :blinkers)
        workout.shadow_roll = has_equipment(legacy_equipment, :shadow_roll)
        workout.wraps = has_equipment(legacy_equipment, :wraps)
        workout.figure_8 = has_equipment(legacy_equipment, :figure_8)
        workout.no_whip = has_equipment(legacy_equipment, :no_whip)
      end
      workout.comment = find_comment(legacy_comment)
      workout.save!
    end

    private

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
  end
end

