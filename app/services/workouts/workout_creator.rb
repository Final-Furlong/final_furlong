module Workouts
  class WorkoutCreator
    def create_workout(horse:, jockey:, surface:,
      condition:, activity1:, distance1:, effort:, blinkers: false,
      shadow_roll: false, wraps: false, figure_8: false, no_whip: false,
      activity2: nil, distance2: nil, activity3: nil, distance3: nil)
      return if Racing::Workout.exists?(horse:, date: Date.current)

      workout = Racing::Workout.new(horse:, date: Date.current)
      workout.jockey = jockey
      workout.condition = condition
      workout.surface = surface.surface
      workout.racetrack = surface.racetrack
      workout.location = workout.racetrack.location
      workout.effort = effort
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
      workout.blinkers = blinkers
      workout.shadow_roll = shadow_roll
      workout.wraps = wraps
      workout.figure_8 = figure_8
      workout.no_whip = no_whip
      workout.save
    end
  end
end

