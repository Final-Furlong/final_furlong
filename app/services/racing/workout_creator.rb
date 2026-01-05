module Racing
  class WorkoutCreator
    def create_workout(date:, horse:, racetrack:, jockey:, surface:,
      condition:, activity1:, distance1:, confidence:, effort:, equipment: nil,
      activity2: nil, distance2: nil, activity3: nil,
      distance3: nil)
      workout = Racing::Workout.find_or_initialize_by(horse:, date:)
      workout.jockey = jockey
      workout.racetrack = racetrack
      workout.location = racetrack.location
      workout.surface = racetrack.surfaces.find_by(surface:)
      workout.condition = condition.downcase
      workout.activity1 = activity1
      workout.distance1 = distance1
      if activity2.present?
        workout.activity2 = activity2
        workout.distance2 = distance2
      end
      if activity3.present?
        workout.activity3 = activity3
        workout.distance3 = distance3
      end
      workout.confidence = confidence
      workout.effort = effort
      if equipment.present?
        workout.blinkers = has_equipment(equipment, :blinkers)
        workout.shadow_roll = has_equipment(equipment, :shadow_roll)
        workout.wraps = has_equipment(equipment, :wraps)
        workout.figure_8 = has_equipment(equipment, :figure_8)
        workout.no_whip = has_equipment(equipment, :no_whip)
      end
      workout.comment = find_comment(legacy_workout.Comment)
      workout.save!
    end

    private

    def find_comment(id)
      line = Legacy::JockeyLine.find(id)
      i18n_key = line.Stat.downcase
      i18n_key = "natural_energy" if i18n_key == "natenergy"
      if line.Value.present?
        i18n_key += "_#{line.Value}"
      end
      Racing::WorkoutComment.find_by(comment_i18n_key: i18n_key)
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

