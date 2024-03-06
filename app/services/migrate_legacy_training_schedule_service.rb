class MigrateLegacyTrainingScheduleService
  attr_reader :legacy_schedule

  def initialize(legacy_schedule:)
    @legacy_schedule = legacy_schedule
  end

  def call
    stable = stable_for(legacy_schedule)
    return unless stable

    return if Racing::TrainingSchedule.exists?(stable:, name: legacy_schedule.Name)
    return if Legacy::TrainingScheduleDetail.where("Schedule" => legacy_schedule.ID).empty?

    schedule = Racing::TrainingSchedule.create!(
      stable:,
      description: legacy_schedule.Description,
      name: name_for(legacy_schedule),
      sunday_activities: sunday_activities(legacy_schedule),
      monday_activities: monday_activities(legacy_schedule),
      tuesday_activities: tuesday_activities(legacy_schedule),
      wednesday_activities: wednesday_activities(legacy_schedule),
      thursday_activities: thursday_activities(legacy_schedule),
      friday_activities: friday_activities(legacy_schedule),
      saturday_activities: saturday_activities(legacy_schedule)
    )
    if legacy_schedule.Horse
      horse = Horses::Horse.find_by(legacy_id: legacy_schedule.Horse)
      Racing::TrainingScheduleHorse.create!(training_schedule: schedule, horse:)
    else
      Legacy::TrainingScheduleHorse.where("Schedule = ?", legacy_schedule.ID).find_each do |schedule_horse|
        horse = Horses::Horse.find_by(legacy_id: schedule_horse.Horse)
        Racing::TrainingScheduleHorse.create!(training_schedule: schedule, horse:)
      end
    end
  end

  private

  def stable_for(schedule)
    stable_id = legacy_schedule.Stable if legacy_schedule.Stable.present?

    if legacy_schedule.Horse.present?
      legacy_horse = Legacy::Horse.find(legacy_schedule.Horse)
      stable_id = legacy_horse.Leaser || legacy_horse.Owner
    end

    Account::Stable.find_by(legacy_id: stable_id)
  end

  def name_for(schedule)
    return schedule.Name if schedule.Name.present?

    legacy_horse = Legacy::Horse.find(legacy_schedule.Horse)
    legacy_horse.name
  end

  def sunday_activities(schedule)
    daily_activities(schedule, "S")
  end

  def monday_activities(schedule)
    daily_activities(schedule, "M")
  end

  def tuesday_activities(schedule)
    daily_activities(schedule, "T")
  end

  def wednesday_activities(schedule)
    daily_activities(schedule, "W")
  end

  def thursday_activities(schedule)
    daily_activities(schedule, "H")
  end

  def friday_activities(schedule)
    daily_activities(schedule, "F")
  end

  def saturday_activities(schedule)
    daily_activities(schedule, "A")
  end

  def daily_activities(schedule, day)
    detail = Legacy::TrainingScheduleDetail.find_by("Schedule" => schedule.ID, "Day" => day)
    return {} unless detail

    activities = { activity1: pick_activity(detail.Activity1), distance1: detail.Distance1 }
    if detail.Activity2.present?
      activities[:activity2] = pick_activity(detail.Activity2)
      activities[:distance2] = detail.Distance2
    end
    if detail.Activity3.present?
      activities[:activity3] = pick_activity(detail.Activity3)
      activities[:distance3] = detail.Distance3
    end

    activities
  end

  def pick_activity(value)
    case value
    when 1
      "walk"
    when 2
      "jog"
    when 3
      "canter"
    when 4
      "gallop"
    when 5
      "breeze"
    end
  end
end

