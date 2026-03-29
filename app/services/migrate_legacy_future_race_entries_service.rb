class MigrateLegacyFutureRaceEntriesService # rubocop:disable Metrics/ClassLength
  def call
    Legacy::FutureEntry.find_each do |legacy_entry|
      migrate_entry(legacy_entry:)
    end
  end

  private

  def migrate_entry(legacy_entry:)
    date = legacy_entry.race.Date - 4.years
    return if date < Date.current

    number = legacy_entry.race.Num
    horse = Horses::Horse.racehorse.find_by(legacy_id: legacy_entry.horse.ID)
    race = Racing::RaceSchedule.find_by(date:, number:)
    return unless horse && race

    entry = Racing::FutureRaceEntry.find_or_initialize_by(horse:, date:)
    entry.race = race
    entry.date = race.date
    entry.created_at = legacy_entry.DateEntered - 4.years
    entry.auto_enter = legacy_entry.AutoEnter
    entry.auto_ship = legacy_entry.AutoShip
    entry.ship_mode = case legacy_entry.ShipMethod
    when "R"
      "road"
    else
      "air"
    end

    entry.racing_style = case legacy_entry.Instructions
    when 1
      "leading"
    when 2
      "off_pace"
    when 3
      "midpack"
    when 4
      "closing"
    end
    entry.first_jockey = Racing::Jockey.find_by(legacy_id: legacy_entry.Jockey)
    entry.second_jockey = Racing::Jockey.find_by(legacy_id: legacy_entry.Jock2)
    entry.third_jockey = Racing::Jockey.find_by(legacy_id: legacy_entry.Jock3)

    if legacy_entry.Equipment.to_i.positive?
      legacy_equipment = Legacy::Equipment.find(legacy_entry.Equipment)
      equipment_list = legacy_equipment.Equipment.split(" ")
      entry.blinkers = equipment_list.include?("B")
      entry.shadow_roll = equipment_list.include?("SR")
      entry.wraps = equipment_list.include?("W")
      entry.figure_8 = equipment_list.include?("F8")
      entry.no_whip = equipment_list.include?("NW")
    end
    ActiveRecord::Base.transaction do
      entry.save!
      data = horse.race_metadata
      if data
        data.next_entry_date = entry.date if data.next_entry_date.blank? || entry.date < data.next_entry_date
      end
    end
  end
end

