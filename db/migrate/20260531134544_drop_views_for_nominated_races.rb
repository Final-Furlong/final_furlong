class DropViewsForNominatedRaces < ActiveRecord::Migration[8.1]
  def change
    drop_view :breeders_cup_classic_qualifiers
    drop_view :breeders_cup_dirt_mile_qualifiers
    drop_view :breeders_cup_distaff_qualifiers
    drop_view :breeders_cup_filly_mare_sprint_qualifiers
    drop_view :breeders_cup_filly_mare_turf_qualifiers
    drop_view :breeders_cup_juvenile_fillies_qualifiers
    drop_view :breeders_cup_juvenile_qualifiers
    drop_view :breeders_cup_juvenile_turf_fillies_qualifiers
    drop_view :breeders_cup_juvenile_turf_qualifiers
    drop_view :breeders_cup_mile_qualifiers
    drop_view :breeders_cup_sc_classic_qualifiers
    drop_view :breeders_cup_sc_distaff_endurance_qualifiers
    drop_view :breeders_cup_sc_distaff_qualifiers
    drop_view :breeders_cup_sc_endurance_qualifiers
    drop_view :breeders_cup_sc_sprint_qualifiers
    drop_view :breeders_cup_sprint_qualifiers
    drop_view :breeders_cup_turf_qualifiers
    drop_view :breeders_cup_turf_sprint_qualifiers
  end
end

