class Workouts::AutoWorkoutJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    return if run_today?
    return unless run_today?(name: "Racing::EnergyFitnessUpdaterJob")
    return unless run_today?(name: "UpdateRacehorseStatsJob")

    yesterday = Date.yesterday
    skipped = 0
    errored = 0
    worked = 0
    errors = []
    weekday = yesterday.strftime("%A").downcase
    step :process do |step|
      Racing::TrainingSchedule.with_activities(weekday).distinct.find_each(start: step.cursor) do |schedule|
        activities = schedule.send("#{weekday}_activities")
        schedule.training_schedule_horses.includes(:horse).where(horse: { status: "racehorse" }).find_each do |training_horse|
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
          activities_list = [{ activity: activities.activity1, distance: activities.distance1 }]
          activities_list << { activity: activities.activity2, distance: activities.distance2 }
          activities_list << { activity: activities.activity3, distance: activities.distance3 }
          params = { effort: Config::Workouts.default_effort, activities_attributes: activities_list }
          params[:blinkers] = true if options.blinkers?
          params[:wraps] = true if options.wraps?
          params[:shadow_roll] = true if options.shadow_roll?
          params[:figure_8] = true if options.figure_8?
          params[:no_whip] = true if options.no_whip?
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
        step.advance! from: schedule.id
      end
    end
    User::SendDeveloperNotifications.call(title: "FF Workouts Finished", message: "#{worked} horses worked!")
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

