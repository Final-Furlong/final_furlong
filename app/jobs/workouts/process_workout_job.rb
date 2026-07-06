class Workouts::ProcessWorkoutJob < ApplicationJob
  queue_as :latency_30s

  retry_on FloatDomainError

  def perform(schedule_id:, horse_id:, date:)
    weekday = date.strftime("%A").downcase
    schedule = Racing::TrainingSchedule.find(schedule_id)
    activities = schedule.send("#{weekday}_activities")
    training_horse = schedule.training_schedule_horses.includes(:horse).where(horse: { id: horse_id }).first
    return if training_horse.blank?

    horse = training_horse.horse
    return if horse.current_boarding.present?
    return if horse.racehorse_metadata.at_home?
    return if horse.race_result_finishes.joins(:race).where(race: { date: }).present?
    return if horse.workouts.where(date:).present?
    return if horse.race_entries.present?

    data = horse.racehorse_metadata
    case horse.manager.user&.setting&.racing&.[](:min_energy_for_workout)
    when "A"
      return if data.energy_grade != "A"
    when "B"
      return if %w[A B].exclude?(data.energy_grade)
    when "C"
      return if %w[A B C].exclude?(data.energy_grade)
    when "D"
      return if %w[A B C D].exclude?(data.energy_grade)
    else
      # go ahead
    end
    racetrack = data.racetrack
    activities_list = [{ activity: activities.activity1, distance: activities.distance1 }]
    activities_list << { activity: activities.activity2, distance: activities.distance2 }
    activities_list << { activity: activities.activity3, distance: activities.distance3 }
    params = { effort: Config::Workouts.default_effort, activities_attributes: activities_list, equipment: horse.race_options&.equipment.to_i }
    Workouts::WorkoutCreator.new.create_workout(
      horse:,
      jockey: pick_jockey(horse),
      surface: pick_surface(horse, racetrack),
      params:,
      date:,
      auto: true
    )
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

