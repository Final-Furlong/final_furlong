class UpdateRaceOptionsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Horses::Horse.racehorse.where.missing(:race_options).find_each do |horse|
      migrate_race_options(horse:)
    end
  end

  private

  def migrate_race_options(horse:)
    race_option = horse.race_options || horse.build_race_options
    jumper = horse.race_result_finishes.joins(:race).merge(Racing::RaceResult.by_track("steeplechase")).exists?
    min_distance = Racing::RaceResult.joins(:horses).where(race_result_horses: { horse_id: horse.id })
      .merge(Racing::RaceResultHorse.by_max_finish(3)).minimum(:distance)
    min_distance ||= 5.0
    max_distance = Racing::RaceResult.joins(:horses).where(race_result_horses: { horse_id: horse.id })
      .merge(Racing::RaceResultHorse.by_max_finish(3)).maximum(:distance)
    max_distance ||= 24.0
    legacy_horse = Legacy::Horse.find(horse.legacy_id)
    jockey1 = legacy_horse.DefaultJock1.blank? ? nil : Racing::Jockey.find_by(legacy_id: legacy_horse.DefaultJock1)
    jockey2 = legacy_horse.DefaultJock2.blank? ? nil : Racing::Jockey.find_by(legacy_id: legacy_horse.DefaultJock2)
    jockey3 = legacy_horse.DefaultJock3.blank? ? nil : Racing::Jockey.find_by(legacy_id: legacy_horse.DefaultJock3)
    racing_style = case legacy_horse.DefaultInstructions
    when 1 then "leading"
    when 2 then "off_pace"
    when 3 then "midpack"
    when 4 then "closing"
    end
    equipment = if legacy_horse.DefaultEquip.present?
      legacy_equip = Legacy::Equipment.find(legacy_horse.DefaultEquip)
      equip_list = legacy_equip.Equipment.split(" ")
      {
        blinkers: equip_list.include?("B"),
        shadow_roll: equip_list.include?("SR"),
        wraps: equip_list.include?("W"),
        figure_8: equip_list.include?("F8"),
        no_whip: equip_list.include?("NW")
      }
    end
    attrs = {
      racehorse_type: jumper ? "jump" : "flat",
      calculated_minimum_distance: min_distance.to_f,
      calculated_maximum_distance: max_distance.to_f,
      first_jockey: jockey1,
      second_jockey: jockey2,
      third_jockey: jockey3,
      racing_style:,
      blinkers: equipment ? equipment[:blinkers] : false,
      shadow_roll: equipment ? equipment[:shadow_roll] : false,
      wraps: equipment ? equipment[:wraps] : false,
      figure_8: equipment ? equipment[:figure_8] : false,
      no_whip: equipment ? equipment[:no_whip] : false
    }
    race_option.update!(attrs)
  end
end

