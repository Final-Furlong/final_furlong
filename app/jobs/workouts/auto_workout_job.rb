class Workouts::AutoWorkoutJob < ApplicationJob
  queue_as :low_priority

  def perform
    # return if run_today?

    yesterday = Date.yesterday
    skipped = 0
    errored = 0
    worked = 0
    errors = []
    weekday = yesterday.strftime("%A").downcase
    Racing::TrainingSchedule.with_activities(weekday).where.associated(:training_schedule_horses).distinct.find_each do |schedule|
      activities = schedule.send("#{weekday}_activities")
      schedule.training_schedule_horses.includes(:horse).where(horse: { status: "racehorse" }).each do |training_horse|
        horse = training_horse.horse
        if horse.current_boarding.present?
          skipped += 1
          next
        end
        if horse.race_metadata.at_home?
          skipped += 1
          next
        end
        if horse.race_result_finishes.joins(:race).where(race: { date: yesterday }).present?
          skipped += 1
          next
        end
        if horse.workouts.where(date: yesterday).present?
          skipped += 1
          next
        end
        data = horse.race_metadata
        case horse.manager.user&.setting&.racing&.[](:min_energy_for_workouts)
        when "A"
          if data.energy_grade != "A"
            skipped += 1
            next
          end
        when "B"
          if %w[A B].exclude?(data.energy_grade)
            skipped += 1
            next
          end
        when "C"
          if %w[A B C].exclude?(data.energy_grade)
            skipped += 1
            next
          end
        when "D"
          if %w[A B C D].exclude?(data.energy_grade)
            skipped += 1
            next
          end
        else
          # go ahead
        end
        racetrack = data.racetrack
        options = horse.race_options
        params = {
          activity1: activities.activity1,
          distance1: activities.distance1,
          effort: Config::Workouts.default_effort
        }
        params.merge!(activity2: activities.activity2, distance2: activities.distance2) if activities.activity2.present?
        params.merge!(activity3: activities.activity3, distance3: activities.distance3) if activities.activity3.present?
        params.merge!(blinkers: true) if options.blinkers?
        params.merge!(wraps: true) if options.wraps?
        params.merge!(shadow_roll: true) if options.shadow_roll?
        params.merge!(figure_8: true) if options.figure_8?
        params.merge!(no_whip: true) if options.no_whip?
        result = Workouts::WorkoutCreator.new.create_workout(
          horse:,
          jockey: pick_jockey(horse),
          surface: pick_surface(horse, racetrack),
          params:,
          date: yesterday,
          auto: true
        )
        if result.created?
          worked += 1
        else
          errored += 1
          errors << result.error
        end
      end
    end
    store_job_info(outcome: { worked:, errored:, skipped:, error: errors.first })
  end

  private

  def pick_surface(horse, racetrack)
    racetrack.surfaces.where(surface: horse.race_options.surface_options).sample
  end

  def pick_jockey(horse)
    options = horse.race_options
    jockeys = []
    if options.first_jockey
      relationship = options.first_jockey.horse_relationships.find_by(horse:)
      jockeys << options.first_jockey if relationship&.experience.to_i < 100
    end
    if jockeys.empty? && options.second_jockey
      relationship = options.second_jockey.horse_relationships.find_by(horse:)
      jockeys << options.second_jockey if relationship&.experience.to_i < 100
    end
    if jockeys.empty? && options.third_jockey
      relationship = options.third_jockey.horse_relationships.find_by(horse:)
      jockeys << options.third_jockey if relationship&.experience.to_i < 100
    end
    if jockeys.empty?
      jockeys << options.first_jockey if options.first_jockey
      jockeys << options.second_jockey if options.second_jockey
      jockeys << options.third_jockey if options.third_jockey
    end
    jockeys = Racing::Jockey.active.send(options.racehorse_type.to_sym) if jockeys.empty?
    jockeys.sample
  end
end

