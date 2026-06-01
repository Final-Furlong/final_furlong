# frozen_string_literal: true

class PopulateRaceSeriesWithBreedersSeries < ActiveRecord::Migration[8.1]
  def up
    series = Racing::RaceSeries.find_or_initialize_by(title: "2yo Dirt Breeders' Series")
    series.update(
      age: "2",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Rainbow Quest Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Planet Hollywood Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Highland Bandit Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "2yo Dirt Fillies Breeders' Series")
    series.update(
      age: "2",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Demand To Know Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Brandywine Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Seeing Starz Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "2yo Turf Breeders' Series")
    series.update(
      age: "2",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Lucky Cigar Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Seabiscuit Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Man O'War Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "2yo Turf Fillies Breeders' Series")
    series.update(
      age: "2",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Dark Magic Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "With Approval Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Eternal Hope Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "3yo Dirt Breeders' Series")
    series.update(
      age: "3",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Cross Roads Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "What's It Worth Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Spectacular Bid Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "3yo Dirt Fillies Breeders' Series")
    series.update(
      age: "3",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Pardon Me Mister Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Evening Flame Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Hollywood Queen Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "3yo Turf Breeders' Series")
    series.update(
      age: "3",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Secretariat Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Bold Ruler Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Cigar Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "3yo Turf Fillies Breeders' Series")
    series.update(
      age: "3",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Amazon Princess Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Nation's Pride Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Highland Sorceress Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "4yo+ Dirt Breeders' Series")
    series.update(
      age: "4+",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Crimson Lad Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Lonesome Glory Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "The Black Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "4yo+ Dirt Mares Breeders' Series")
    series.update(
      age: "4+",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Lymerick Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Ifyoucouldseemenow Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Miss Hayday Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "4yo+ Turf Breeders' Series")
    series.update(
      age: "4+",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Valid Wager Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "A.P. Indy Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Omaha Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "4yo+ Turf Mares Breeders' Series")
    series.update(
      age: "4+",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Fire de Flame Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "That's Debatable Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Highland Raven Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "Steeplechase Breeders' Series")
    series.update(
      age: "3+",
      female_only: false,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Moonover Boy Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Highland Rogue Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Townsend Prince Breeders' Stakes")
    )
    series = Racing::RaceSeries.find_or_initialize_by(title: "Steeplechase Fillies/Mares Breeders' Series")
    series.update(
      age: "3+",
      female_only: true,
      first_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Townsend Holly Breeders' Stakes"),
      second_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Backstage Pass Breeders' Stakes"),
      third_race: Racing::RaceSchedule.find_by(race_type: "stakes", name: "Dream Skipper Breeders' Stakes")
    )
  end

  def down
    Racing::RaceSeries.where("title LIKE ?", "% Breeders%").delete_all
  end
end

