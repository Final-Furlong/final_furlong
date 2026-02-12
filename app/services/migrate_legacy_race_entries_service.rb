class MigrateLegacyRaceEntriesService # rubocop:disable Metrics/ClassLength
  def call
    Legacy::RaceEntry.find_each do |legacy_entry|
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

    entry = Racing::RaceEntry.find_or_initialize_by(horse:, date:, race:)
    entry.created_at = legacy_entry.EntryDate
    entry.post_parade = legacy_entry.PP.presence || 0
    entry.weight = legacy_entry.Weight.presence || 0
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
    entry.first_jockey = Racing::Jockey.find_by(legacy_id: legacy_entry.Jock1)
    entry.second_jockey = Racing::Jockey.find_by(legacy_id: legacy_entry.Jock2)
    entry.third_jockey = Racing::Jockey.find_by(legacy_id: legacy_entry.Jock3)
    entry.jockey = Racing::Jockey.find_by(legacy_id: legacy_entry.Jockey)
    entry.odd = Racing::Odd.find_by(display: Legacy::Odd.find_by(ID: legacy_entry.Odds)&.Odds)

    if legacy_entry.Equipment.to_i.positive?
      legacy_equipment = Legacy::Equipment.find(legacy_entry.Equipment)
      equipment_list = legacy_equipment.Equipment.split(" ")
      entry.blinkers = equipment_list.include?("B")
      entry.shadow_roll = equipment_list.include?("SR")
      entry.wraps = equipment_list.include?("W")
      entry.figure_8 = equipment_list.include?("F8")
      entry.no_whip = equipment_list.include?("NW")
    end
    entry.save!
  end
end

