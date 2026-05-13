# frozen_string_literal: true

class UpdateBreedersCupRaces < ActiveRecord::Migration[8.1]
  def up
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Juvenile")&.update(male_only: true, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Juvenile Turf")&.update(male_only: true, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Juvenile Fillies")&.update(male_only: false, female_only: true)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Juvenile Turf Fillies")&.update(male_only: false, female_only: true)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Sprint")&.update(male_only: true, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Turf Sprint")&.update(male_only: false, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Filly & Mare Sprint")&.update(male_only: false, female_only: true)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Mile")&.update(male_only: false, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Dirt Mile")&.update(male_only: false, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Classic")&.update(male_only: false, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Turf")&.update(male_only: false, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Filly & Mare Turf")&.update(male_only: false, female_only: true)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup Distaff")&.update(male_only: false, female_only: true)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup SC Sprint")&.update(male_only: false, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup SC Classic")&.update(male_only: true, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup SC Endurance")&.update(male_only: true, female_only: false)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup SC Distaff")&.update(male_only: false, female_only: true)
    Racing::RaceSchedule.find_by(name: "Breeders' Cup SC Distaff Endurance")&.update(male_only: false, female_only: true)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

