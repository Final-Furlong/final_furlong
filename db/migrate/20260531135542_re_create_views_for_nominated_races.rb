class ReCreateViewsForNominatedRaces < ActiveRecord::Migration[8.1]
  def change
    create_view :breeders_cup_classic_qualifiers, materialized: true
    add_index :breeders_cup_classic_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_classic_qualifiers, :stakes_wins
    add_index :breeders_cup_classic_qualifiers, :stakes_seconds
    add_index :breeders_cup_classic_qualifiers, :stakes_thirds
    add_index :breeders_cup_classic_qualifiers, :allowance_wins
    add_index :breeders_cup_classic_qualifiers, :points
    add_index :breeders_cup_classic_qualifiers, :nominated

    create_view :breeders_cup_dirt_mile_qualifiers, materialized: true
    add_index :breeders_cup_dirt_mile_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_dirt_mile_qualifiers, :stakes_wins
    add_index :breeders_cup_dirt_mile_qualifiers, :stakes_seconds
    add_index :breeders_cup_dirt_mile_qualifiers, :stakes_thirds
    add_index :breeders_cup_dirt_mile_qualifiers, :allowance_wins
    add_index :breeders_cup_dirt_mile_qualifiers, :points
    add_index :breeders_cup_dirt_mile_qualifiers, :nominated

    create_view :breeders_cup_distaff_qualifiers, materialized: true
    add_index :breeders_cup_distaff_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_distaff_qualifiers, :stakes_wins
    add_index :breeders_cup_distaff_qualifiers, :stakes_seconds
    add_index :breeders_cup_distaff_qualifiers, :stakes_thirds
    add_index :breeders_cup_distaff_qualifiers, :allowance_wins
    add_index :breeders_cup_distaff_qualifiers, :points
    add_index :breeders_cup_distaff_qualifiers, :nominated

    create_view :breeders_cup_filly_mare_sprint_qualifiers, materialized: true
    add_index :breeders_cup_filly_mare_sprint_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_filly_mare_sprint_qualifiers, :stakes_wins
    add_index :breeders_cup_filly_mare_sprint_qualifiers, :stakes_seconds
    add_index :breeders_cup_filly_mare_sprint_qualifiers, :stakes_thirds
    add_index :breeders_cup_filly_mare_sprint_qualifiers, :allowance_wins
    add_index :breeders_cup_filly_mare_sprint_qualifiers, :points
    add_index :breeders_cup_filly_mare_sprint_qualifiers, :nominated

    create_view :breeders_cup_filly_mare_turf_qualifiers, materialized: true
    add_index :breeders_cup_filly_mare_turf_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_filly_mare_turf_qualifiers, :stakes_wins
    add_index :breeders_cup_filly_mare_turf_qualifiers, :stakes_seconds
    add_index :breeders_cup_filly_mare_turf_qualifiers, :stakes_thirds
    add_index :breeders_cup_filly_mare_turf_qualifiers, :allowance_wins
    add_index :breeders_cup_filly_mare_turf_qualifiers, :points
    add_index :breeders_cup_filly_mare_turf_qualifiers, :nominated

    create_view :breeders_cup_juvenile_fillies_qualifiers, materialized: true
    add_index :breeders_cup_juvenile_fillies_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_juvenile_fillies_qualifiers, :stakes_wins
    add_index :breeders_cup_juvenile_fillies_qualifiers, :stakes_seconds
    add_index :breeders_cup_juvenile_fillies_qualifiers, :stakes_thirds
    add_index :breeders_cup_juvenile_fillies_qualifiers, :allowance_wins
    add_index :breeders_cup_juvenile_fillies_qualifiers, :points
    add_index :breeders_cup_juvenile_fillies_qualifiers, :nominated

    create_view :breeders_cup_juvenile_qualifiers, materialized: true
    add_index :breeders_cup_juvenile_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_juvenile_qualifiers, :stakes_wins
    add_index :breeders_cup_juvenile_qualifiers, :stakes_seconds
    add_index :breeders_cup_juvenile_qualifiers, :stakes_thirds
    add_index :breeders_cup_juvenile_qualifiers, :allowance_wins
    add_index :breeders_cup_juvenile_qualifiers, :points
    add_index :breeders_cup_juvenile_qualifiers, :nominated

    create_view :breeders_cup_juvenile_turf_fillies_qualifiers, materialized: true
    add_index :breeders_cup_juvenile_turf_fillies_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_juvenile_turf_fillies_qualifiers, :stakes_wins
    add_index :breeders_cup_juvenile_turf_fillies_qualifiers, :stakes_seconds
    add_index :breeders_cup_juvenile_turf_fillies_qualifiers, :stakes_thirds
    add_index :breeders_cup_juvenile_turf_fillies_qualifiers, :allowance_wins
    add_index :breeders_cup_juvenile_turf_fillies_qualifiers, :points
    add_index :breeders_cup_juvenile_turf_fillies_qualifiers, :nominated

    create_view :breeders_cup_juvenile_turf_qualifiers, materialized: true
    add_index :breeders_cup_juvenile_turf_qualifiers, :horse_id
    add_index :breeders_cup_juvenile_turf_qualifiers, :stakes_wins
    add_index :breeders_cup_juvenile_turf_qualifiers, :stakes_seconds
    add_index :breeders_cup_juvenile_turf_qualifiers, :stakes_thirds
    add_index :breeders_cup_juvenile_turf_qualifiers, :allowance_wins
    add_index :breeders_cup_juvenile_turf_qualifiers, :points
    add_index :breeders_cup_juvenile_turf_qualifiers, :nominated

    create_view :breeders_cup_mile_qualifiers, materialized: true
    add_index :breeders_cup_mile_qualifiers, :horse_id
    add_index :breeders_cup_mile_qualifiers, :stakes_wins
    add_index :breeders_cup_mile_qualifiers, :stakes_seconds
    add_index :breeders_cup_mile_qualifiers, :stakes_thirds
    add_index :breeders_cup_mile_qualifiers, :allowance_wins
    add_index :breeders_cup_mile_qualifiers, :points
    add_index :breeders_cup_mile_qualifiers, :nominated

    create_view :breeders_cup_sc_classic_qualifiers, materialized: true
    add_index :breeders_cup_sc_classic_qualifiers, :horse_id
    add_index :breeders_cup_sc_classic_qualifiers, :stakes_wins
    add_index :breeders_cup_sc_classic_qualifiers, :stakes_seconds
    add_index :breeders_cup_sc_classic_qualifiers, :stakes_thirds
    add_index :breeders_cup_sc_classic_qualifiers, :allowance_wins
    add_index :breeders_cup_sc_classic_qualifiers, :points
    add_index :breeders_cup_sc_classic_qualifiers, :nominated

    create_view :breeders_cup_sc_distaff_endurance_qualifiers, materialized: true
    add_index :breeders_cup_sc_distaff_endurance_qualifiers, :horse_id
    add_index :breeders_cup_sc_distaff_endurance_qualifiers, :stakes_wins
    add_index :breeders_cup_sc_distaff_endurance_qualifiers, :stakes_seconds
    add_index :breeders_cup_sc_distaff_endurance_qualifiers, :stakes_thirds
    add_index :breeders_cup_sc_distaff_endurance_qualifiers, :allowance_wins
    add_index :breeders_cup_sc_distaff_endurance_qualifiers, :points
    add_index :breeders_cup_sc_distaff_endurance_qualifiers, :nominated

    create_view :breeders_cup_sc_distaff_qualifiers, materialized: true
    add_index :breeders_cup_sc_distaff_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_sc_distaff_qualifiers, :stakes_wins
    add_index :breeders_cup_sc_distaff_qualifiers, :stakes_seconds
    add_index :breeders_cup_sc_distaff_qualifiers, :stakes_thirds
    add_index :breeders_cup_sc_distaff_qualifiers, :allowance_wins
    add_index :breeders_cup_sc_distaff_qualifiers, :points
    add_index :breeders_cup_sc_distaff_qualifiers, :nominated

    create_view :breeders_cup_sc_endurance_qualifiers, materialized: true
    add_index :breeders_cup_sc_endurance_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_sc_endurance_qualifiers, :stakes_wins
    add_index :breeders_cup_sc_endurance_qualifiers, :stakes_seconds
    add_index :breeders_cup_sc_endurance_qualifiers, :stakes_thirds
    add_index :breeders_cup_sc_endurance_qualifiers, :allowance_wins
    add_index :breeders_cup_sc_endurance_qualifiers, :points
    add_index :breeders_cup_sc_endurance_qualifiers, :nominated

    create_view :breeders_cup_sc_sprint_qualifiers, materialized: true
    add_index :breeders_cup_sc_sprint_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_sc_sprint_qualifiers, :stakes_wins
    add_index :breeders_cup_sc_sprint_qualifiers, :stakes_seconds
    add_index :breeders_cup_sc_sprint_qualifiers, :stakes_thirds
    add_index :breeders_cup_sc_sprint_qualifiers, :allowance_wins
    add_index :breeders_cup_sc_sprint_qualifiers, :points
    add_index :breeders_cup_sc_sprint_qualifiers, :nominated

    create_view :breeders_cup_sprint_qualifiers, materialized: true
    add_index :breeders_cup_sprint_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_sprint_qualifiers, :stakes_wins
    add_index :breeders_cup_sprint_qualifiers, :stakes_seconds
    add_index :breeders_cup_sprint_qualifiers, :stakes_thirds
    add_index :breeders_cup_sprint_qualifiers, :allowance_wins
    add_index :breeders_cup_sprint_qualifiers, :points
    add_index :breeders_cup_sprint_qualifiers, :nominated

    create_view :breeders_cup_turf_qualifiers, materialized: true
    add_index :breeders_cup_turf_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_turf_qualifiers, :stakes_wins
    add_index :breeders_cup_turf_qualifiers, :stakes_seconds
    add_index :breeders_cup_turf_qualifiers, :stakes_thirds
    add_index :breeders_cup_turf_qualifiers, :allowance_wins
    add_index :breeders_cup_turf_qualifiers, :points
    add_index :breeders_cup_turf_qualifiers, :nominated

    create_view :breeders_cup_turf_sprint_qualifiers, materialized: true
    add_index :breeders_cup_turf_sprint_qualifiers, :horse_id, unique: true
    add_index :breeders_cup_turf_sprint_qualifiers, :stakes_wins
    add_index :breeders_cup_turf_sprint_qualifiers, :stakes_seconds
    add_index :breeders_cup_turf_sprint_qualifiers, :stakes_thirds
    add_index :breeders_cup_turf_sprint_qualifiers, :allowance_wins
    add_index :breeders_cup_turf_sprint_qualifiers, :points
    add_index :breeders_cup_turf_sprint_qualifiers, :nominated

    create_view :breeders_series_2yo_dirt_qualifiers, materialized: true
    add_index :breeders_series_2yo_dirt_qualifiers, :horse_id, unique: true
    add_index :breeders_series_2yo_dirt_qualifiers, :stakes_wins
    add_index :breeders_series_2yo_dirt_qualifiers, :stakes_seconds
    add_index :breeders_series_2yo_dirt_qualifiers, :stakes_thirds
    add_index :breeders_series_2yo_dirt_qualifiers, :allowance_wins
    add_index :breeders_series_2yo_dirt_qualifiers, :points

    create_view :breeders_series_2yo_fillies_dirt_qualifiers, materialized: true
    add_index :breeders_series_2yo_fillies_dirt_qualifiers, :horse_id, unique: true
    add_index :breeders_series_2yo_fillies_dirt_qualifiers, :stakes_wins
    add_index :breeders_series_2yo_fillies_dirt_qualifiers, :stakes_seconds
    add_index :breeders_series_2yo_fillies_dirt_qualifiers, :stakes_thirds
    add_index :breeders_series_2yo_fillies_dirt_qualifiers, :allowance_wins
    add_index :breeders_series_2yo_fillies_dirt_qualifiers, :points

    create_view :breeders_series_2yo_fillies_turf_qualifiers, materialized: true
    add_index :breeders_series_2yo_fillies_turf_qualifiers, :horse_id, unique: true
    add_index :breeders_series_2yo_fillies_turf_qualifiers, :stakes_wins
    add_index :breeders_series_2yo_fillies_turf_qualifiers, :stakes_seconds
    add_index :breeders_series_2yo_fillies_turf_qualifiers, :stakes_thirds
    add_index :breeders_series_2yo_fillies_turf_qualifiers, :allowance_wins
    add_index :breeders_series_2yo_fillies_turf_qualifiers, :points

    create_view :breeders_series_2yo_turf_qualifiers, materialized: true
    add_index :breeders_series_2yo_turf_qualifiers, :horse_id, unique: true
    add_index :breeders_series_2yo_turf_qualifiers, :stakes_wins
    add_index :breeders_series_2yo_turf_qualifiers, :stakes_seconds
    add_index :breeders_series_2yo_turf_qualifiers, :stakes_thirds
    add_index :breeders_series_2yo_turf_qualifiers, :allowance_wins
    add_index :breeders_series_2yo_turf_qualifiers, :points

    create_view :breeders_series_3yo_dirt_qualifiers, materialized: true
    add_index :breeders_series_3yo_dirt_qualifiers, :horse_id, unique: true
    add_index :breeders_series_3yo_dirt_qualifiers, :stakes_wins
    add_index :breeders_series_3yo_dirt_qualifiers, :stakes_seconds
    add_index :breeders_series_3yo_dirt_qualifiers, :stakes_thirds
    add_index :breeders_series_3yo_dirt_qualifiers, :allowance_wins
    add_index :breeders_series_3yo_dirt_qualifiers, :points

    create_view :breeders_series_3yo_fillies_dirt_qualifiers, materialized: true
    add_index :breeders_series_3yo_fillies_dirt_qualifiers, :horse_id, unique: true
    add_index :breeders_series_3yo_fillies_dirt_qualifiers, :stakes_wins
    add_index :breeders_series_3yo_fillies_dirt_qualifiers, :stakes_seconds
    add_index :breeders_series_3yo_fillies_dirt_qualifiers, :stakes_thirds
    add_index :breeders_series_3yo_fillies_dirt_qualifiers, :allowance_wins
    add_index :breeders_series_3yo_fillies_dirt_qualifiers, :points

    create_view :breeders_series_3yo_fillies_turf_qualifiers, materialized: true
    add_index :breeders_series_3yo_fillies_turf_qualifiers, :horse_id, unique: true
    add_index :breeders_series_3yo_fillies_turf_qualifiers, :stakes_wins
    add_index :breeders_series_3yo_fillies_turf_qualifiers, :stakes_seconds
    add_index :breeders_series_3yo_fillies_turf_qualifiers, :stakes_thirds
    add_index :breeders_series_3yo_fillies_turf_qualifiers, :allowance_wins
    add_index :breeders_series_3yo_fillies_turf_qualifiers, :points

    create_view :breeders_series_3yo_turf_qualifiers, materialized: true
    add_index :breeders_series_3yo_turf_qualifiers, :horse_id, unique: true
    add_index :breeders_series_3yo_turf_qualifiers, :stakes_wins
    add_index :breeders_series_3yo_turf_qualifiers, :stakes_seconds
    add_index :breeders_series_3yo_turf_qualifiers, :stakes_thirds
    add_index :breeders_series_3yo_turf_qualifiers, :allowance_wins
    add_index :breeders_series_3yo_turf_qualifiers, :points

    create_view :breeders_series_4yo_dirt_qualifiers, materialized: true
    add_index :breeders_series_4yo_dirt_qualifiers, :horse_id, unique: true
    add_index :breeders_series_4yo_dirt_qualifiers, :stakes_wins
    add_index :breeders_series_4yo_dirt_qualifiers, :stakes_seconds
    add_index :breeders_series_4yo_dirt_qualifiers, :stakes_thirds
    add_index :breeders_series_4yo_dirt_qualifiers, :allowance_wins
    add_index :breeders_series_4yo_dirt_qualifiers, :points

    create_view :breeders_series_4yo_mares_dirt_qualifiers, materialized: true
    add_index :breeders_series_4yo_mares_dirt_qualifiers, :horse_id, unique: true
    add_index :breeders_series_4yo_mares_dirt_qualifiers, :stakes_wins
    add_index :breeders_series_4yo_mares_dirt_qualifiers, :stakes_seconds
    add_index :breeders_series_4yo_mares_dirt_qualifiers, :stakes_thirds
    add_index :breeders_series_4yo_mares_dirt_qualifiers, :allowance_wins
    add_index :breeders_series_4yo_mares_dirt_qualifiers, :points

    create_view :breeders_series_4yo_mares_turf_qualifiers, materialized: true
    add_index :breeders_series_4yo_mares_turf_qualifiers, :horse_id, unique: true
    add_index :breeders_series_4yo_mares_turf_qualifiers, :stakes_wins
    add_index :breeders_series_4yo_mares_turf_qualifiers, :stakes_seconds
    add_index :breeders_series_4yo_mares_turf_qualifiers, :stakes_thirds
    add_index :breeders_series_4yo_mares_turf_qualifiers, :allowance_wins
    add_index :breeders_series_4yo_mares_turf_qualifiers, :points

    create_view :breeders_series_4yo_turf_qualifiers, materialized: true
    add_index :breeders_series_4yo_turf_qualifiers, :horse_id, unique: true
    add_index :breeders_series_4yo_turf_qualifiers, :stakes_wins
    add_index :breeders_series_4yo_turf_qualifiers, :stakes_seconds
    add_index :breeders_series_4yo_turf_qualifiers, :stakes_thirds
    add_index :breeders_series_4yo_turf_qualifiers, :allowance_wins
    add_index :breeders_series_4yo_turf_qualifiers, :points

    create_view :breeders_series_steeplechase_fillies_qualifiers, materialized: true
    add_index :breeders_series_steeplechase_fillies_qualifiers, :horse_id, unique: true
    add_index :breeders_series_steeplechase_fillies_qualifiers, :stakes_wins
    add_index :breeders_series_steeplechase_fillies_qualifiers, :stakes_seconds
    add_index :breeders_series_steeplechase_fillies_qualifiers, :stakes_thirds
    add_index :breeders_series_steeplechase_fillies_qualifiers, :allowance_wins
    add_index :breeders_series_steeplechase_fillies_qualifiers, :points

    create_view :breeders_series_steeplechase_qualifiers, materialized: true
    add_index :breeders_series_steeplechase_qualifiers, :horse_id, unique: true
    add_index :breeders_series_steeplechase_qualifiers, :stakes_wins
    add_index :breeders_series_steeplechase_qualifiers, :stakes_seconds
    add_index :breeders_series_steeplechase_qualifiers, :stakes_thirds
    add_index :breeders_series_steeplechase_qualifiers, :allowance_wins
    add_index :breeders_series_steeplechase_qualifiers, :points
  end
end

