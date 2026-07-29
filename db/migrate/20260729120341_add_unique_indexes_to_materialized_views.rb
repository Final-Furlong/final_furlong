class AddUniqueIndexesToMaterializedViews < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :broodmare_foal_records, :horse_id, if_exists: true
    add_index :broodmare_foal_records, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :stud_foal_records, :horse_id, if_exists: true
    add_index :stud_foal_records, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true

    remove_index :race_records, %i[horse_id year surface], if_exists: true
    add_index :race_records, %i[horse_id year surface], unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :race_qualifications, :horse_id, if_exists: true
    add_index :race_qualifications, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :annual_race_records, %i[horse_id year], if_exists: true
    add_index :annual_race_records, %i[horse_id year], unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :lifetime_race_records, :horse_id, if_exists: true
    add_index :lifetime_race_records, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true

    remove_index :breeders_cup_juvenile_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_juvenile_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_juvenile_fillies_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_juvenile_fillies_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_juvenile_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_juvenile_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_juvenile_turf_fillies_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_juvenile_turf_fillies_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_distaff_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_distaff_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_filly_mare_sprint_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_filly_mare_sprint_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_filly_mare_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_filly_mare_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_sprint_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_sprint_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_mile_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_mile_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_dirt_mile_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_dirt_mile_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_classic_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_classic_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_turf_sprint_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_turf_sprint_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_sc_sprint_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_sc_sprint_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_sc_classic_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_sc_classic_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_sc_endurance_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_sc_endurance_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_sc_distaff_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_sc_distaff_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_cup_sc_distaff_endurance_qualifiers, :horse_id, if_exists: true
    add_index :breeders_cup_sc_distaff_endurance_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true

    remove_index :breeders_series_2yo_dirt_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_2yo_dirt_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_2yo_fillies_dirt_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_2yo_fillies_dirt_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_2yo_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_2yo_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_2yo_fillies_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_2yo_fillies_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_3yo_dirt_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_3yo_dirt_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_3yo_fillies_dirt_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_3yo_fillies_dirt_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_3yo_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_3yo_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_3yo_fillies_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_3yo_fillies_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_4yo_dirt_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_4yo_dirt_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_4yo_mares_dirt_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_4yo_mares_dirt_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_4yo_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_4yo_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_4yo_mares_turf_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_4yo_mares_turf_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_steeplechase_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_steeplechase_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :breeders_series_steeplechase_fillies_qualifiers, :horse_id, if_exists: true
    add_index :breeders_series_steeplechase_fillies_qualifiers, :horse_id, unique: true, algorithm: :concurrently, if_not_exists: true

    remove_index :stable_race_records, %i[stable_id year surface], if_exists: true
    add_index :stable_race_records, %i[stable_id year surface], unique: true, algorithm: :concurrently, if_not_exists: true
    remove_index :stable_race_records, %i[stable_id year], if_exists: true
    add_index :stable_annual_race_records, %i[stable_id year], unique: true, algorithm: :concurrently, if_not_exists: true
  end
end

