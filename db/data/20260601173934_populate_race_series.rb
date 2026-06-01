# frozen_string_literal: true

class PopulateRaceSeries < ActiveRecord::Migration[8.1]
  def up
    series_2yo = Racing::RaceSeries.find_or_initialize_by(title: "2yo Triple Crown")
    series_2yo.update(
      age: "2",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Hopeful Stakes", age: "2"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Futurity Stakes", age: "2"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Champagne Stakes", age: "2")
    )
    series_2yo = Racing::RaceSeries.find_or_initialize_by(title: "2yo Triple Tiara")
    series_2yo.update(
      age: "2",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Spinaway Stakes", age: "2"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Matron Stakes", age: "2"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Frizette Stakes", age: "2")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo Triple Crown")
    series_3yo.update(
      age: "3",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Kentucky Derby", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Preakness Stakes", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Belmont Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo Canadian Triple Crown")
    series_3yo.update(
      age: "3",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Queen's Plate Stakes", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Prince of Wales Stakes", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Breeders' Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo Turf Triple Crown")
    series_3yo.update(
      age: "3",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "American Classic", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "American Derby", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Secretariat Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo English Triple Crown")
    series_3yo.update(
      age: "3",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Two Thousand Guineas", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Epsom Derby", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "St. Leger Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo Irish Triple Crown")
    series_3yo.update(
      age: "3",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Irish Two Thousand Guineas", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Irish Derby", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Irish St. Leger Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo Triple Tiara")
    series_3yo.update(
      age: "3",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Mother Goose Stakes", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Coaching Club American Oaks", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Alabama Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo Canadian Triple Tiara")
    series_3yo.update(
      age: "3",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Woodbine Oaks", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Bison City Stakes", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Wonder Where Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo Turf Triple Tiara")
    series_3yo.update(
      age: "3",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Sands Point Stakes", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "American Oaks", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Lake Placid Handicap", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo English Triple Tiara")
    series_3yo.update(
      age: "3",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "One Thousand Guineas", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Epsom Oaks Stakes", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "St. Leger Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo Irish Triple Tiara")
    series_3yo.update(
      age: "3",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Irish One Thousand Guineas", age: "3"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Irish Oaks Stakes", age: "3"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Irish St. Leger Stakes", age: "3")
    )
    series_3yo = Racing::RaceSeries.find_or_initialize_by(title: "3yo+ Australian Triple Crown")
    series_3yo.update(
      age: "3+",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Cox Plate", age: "3+"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Caulfield Cup", age: "3+"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Melbourne Cup", age: "3+")
    )
    series_older = Racing::RaceSeries.find_or_initialize_by(title: "Older Triple Crown")
    series_older.update(
      age: "3+",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Metropolitan Stakes", age: "3+"), # 8f dirt,may
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Brooklyn Handicap", age: "3+"), # 9f dirt,june
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Suburban Handicap", age: "3+") # 10f dirt, july
    )
    series_older = Racing::RaceSeries.find_or_initialize_by(title: "Steeplechase Triple Crown")
    series_older.update(
      age: "3+",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Hard Scuffle Stakes", age: "3+"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Joe Aitcheson Stakes", age: "3+"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Meadow Brook Stakes", age: "3+")
    )
    series_older = Racing::RaceSeries.find_or_initialize_by(title: "Steeplechase Triple Tiara")
    series_older.update(
      age: "3+",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Set In Her Ways Stakes", age: "3+"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Townsend Mischief Stakes", age: "3+"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Cross My Heart Stakes", age: "3+")
    )
  end

  def down
    Racing::RaceSeries.delete_all
  end
end

