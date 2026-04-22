class PopulateTrackSeasons < ActiveRecord::Migration[8.1]
  def up
    location = Racing::Racetrack.find_by(name: "Arlington").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 36, good_chance: 45, wet_chance: 11, slow_chance: 8)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 38, good_chance: 51, wet_chance: 8, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 46, good_chance: 46, wet_chance: 6, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 41, good_chance: 50, wet_chance: 7, slow_chance: 2)

    location = Racing::Racetrack.find_by(name: "Aqueduct").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 38, good_chance: 45, wet_chance: 10, slow_chance: 7)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 37, good_chance: 50, wet_chance: 10, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 48, good_chance: 45, wet_chance: 5, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 39, good_chance: 50, wet_chance: 8, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Belmont").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 38, good_chance: 45, wet_chance: 10, slow_chance: 7)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 37, good_chance: 50, wet_chance: 10, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 48, good_chance: 45, wet_chance: 5, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 39, good_chance: 50, wet_chance: 8, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Churchill Downs").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 40, good_chance: 46, wet_chance: 9, slow_chance: 5)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 35, good_chance: 51, wet_chance: 11, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 47, good_chance: 45, wet_chance: 6, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 40, good_chance: 50, wet_chance: 7, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Del Mar").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 48, good_chance: 45, wet_chance: 5, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 56, good_chance: 40, wet_chance: 3, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 60, good_chance: 37, wet_chance: 2, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 45, good_chance: 47, wet_chance: 5, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Gulfstream").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 45, good_chance: 46, wet_chance: 6, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 39, good_chance: 46, wet_chance: 11, slow_chance: 4)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 40, good_chance: 50, wet_chance: 7, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 43, good_chance: 48, wet_chance: 6, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Santa Anita").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 48, good_chance: 45, wet_chance: 5, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 56, good_chance: 40, wet_chance: 3, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 60, good_chance: 37, wet_chance: 2, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 45, good_chance: 47, wet_chance: 5, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Fort Erie").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 40, good_chance: 46, wet_chance: 9, slow_chance: 5)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 35, good_chance: 51, wet_chance: 11, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 47, good_chance: 45, wet_chance: 6, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 40, good_chance: 50, wet_chance: 7, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Pimlico").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 40, good_chance: 45, wet_chance: 9, slow_chance: 6)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 38, good_chance: 50, wet_chance: 9, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 46, good_chance: 44, wet_chance: 7, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 46, good_chance: 45, wet_chance: 6, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Saratoga").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 38, good_chance: 45, wet_chance: 10, slow_chance: 7)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 37, good_chance: 50, wet_chance: 10, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 48, good_chance: 45, wet_chance: 5, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 39, good_chance: 50, wet_chance: 8, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Woodbine").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 34, good_chance: 40, wet_chance: 9, slow_chance: 5)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 35, good_chance: 51, wet_chance: 11, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 47, good_chance: 45, wet_chance: 6, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 40, good_chance: 50, wet_chance: 7, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Calder").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 37, good_chance: 45, wet_chance: 6, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 39, good_chance: 46, wet_chance: 11, slow_chance: 4)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 40, good_chance: 50, wet_chance: 7, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 43, good_chance: 48, wet_chance: 6, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Lone Star").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 45, good_chance: 46, wet_chance: 6, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 37, good_chance: 49, wet_chance: 11, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 60, good_chance: 37, wet_chance: 2, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 45, good_chance: 47, wet_chance: 5, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Australia").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 60, good_chance: 37, wet_chance: 2, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 45, good_chance: 47, wet_chance: 5, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 45, good_chance: 46, wet_chance: 6, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 37, good_chance: 49, wet_chance: 11, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Dubai").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 59, good_chance: 38, wet_chance: 2, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 58, good_chance: 39, wet_chance: 2, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 60, good_chance: 37, wet_chance: 2, slow_chance: 1)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 58, good_chance: 39, wet_chance: 2, slow_chance: 1)

    location = Racing::Racetrack.find_by(name: "England").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 39, good_chance: 46, wet_chance: 9, slow_chance: 6)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 38, good_chance: 51, wet_chance: 8, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 45, good_chance: 48, wet_chance: 5, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 40, good_chance: 51, wet_chance: 6, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Ireland").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 36, good_chance: 47, wet_chance: 11, slow_chance: 6)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 35, good_chance: 52, wet_chance: 10, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 42, good_chance: 49, wet_chance: 7, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 37, good_chance: 52, wet_chance: 8, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Hong Kong").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 40, good_chance: 46, wet_chance: 9, slow_chance: 5)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 35, good_chance: 51, wet_chance: 11, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 47, good_chance: 45, wet_chance: 6, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 40, good_chance: 50, wet_chance: 7, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "Japan").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 37, good_chance: 47, wet_chance: 11, slow_chance: 5)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 32, good_chance: 52, wet_chance: 13, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 44, good_chance: 46, wet_chance: 8, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 37, good_chance: 51, wet_chance: 9, slow_chance: 3)

    location = Racing::Racetrack.find_by(name: "France").location
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "winter")
    info.update(fast_chance: 40, good_chance: 46, wet_chance: 9, slow_chance: 5)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "spring")
    info.update(fast_chance: 35, good_chance: 51, wet_chance: 11, slow_chance: 3)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "summer")
    info.update(fast_chance: 47, good_chance: 45, wet_chance: 6, slow_chance: 2)
    info = Racing::TrackSeasonInfo.find_or_initialize_by(location:, season: "fall")
    info.update(fast_chance: 40, good_chance: 50, wet_chance: 7, slow_chance: 3)
  end

  def down
    Racing::TrackSeasonInfo.delete_all
    raise ActiveRecord::IrreversibleMigration
  end
end

