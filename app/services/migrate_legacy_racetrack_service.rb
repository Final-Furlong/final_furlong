class MigrateLegacyRacetrackService # rubocop:disable Metrics/ClassLength
  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    arlington = Location.find_or_create_by(name: "Arlington Heights, IL", state: "Illinois", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Arlington", location: arlington, latitude: 42.093345,
                                                longitude: -88.010049)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 90, length: 5940, turn_to_finish_length: 1545, turn_distance: 1545, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 150, length: 5280, turn_to_finish_length: 932, turn_distance: 1373,
      banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 150, length: 5280, turn_to_finish_length: 932,
      turn_distance: 1373, banking: 4, jumps: 7
    )

    aqueduct = Location.find_or_create_by(name: "Queens, NY", state: "New York", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Aqueduct", location: aqueduct, latitude: 40.672672402365784,
                                                longitude: -73.83568944359783)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 80, length: 5940, turn_to_finish_length: 1156, turn_distance: 1492, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 70, length: 4663, turn_to_finish_length: 1175, turn_distance: 1160,
      banking: 6
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 70, length: 4663, turn_to_finish_length: 1175,
      turn_distance: 1160, banking: 6, jumps: 7
    )

    belmont = Location.find_or_create_by(name: "Elmont, NY", state: "New York", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Belmont", location: belmont, latitude: 40.714097026488375,
                                                longitude: -73.72339058827338)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 90, length: 7920, turn_to_finish_length: 1097, turn_distance: 2016, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 80, length: 6957, turn_to_finish_length: 1124, turn_distance: 1290,
      banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 80, length: 6957, turn_to_finish_length: 1124,
      turn_distance: 1290, banking: 4, jumps: 8
    )

    churchill = Location.find_or_create_by(name: "Louisville, KY", state: "Kentucky", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Churchill Downs", location: churchill, latitude: 38.203952813579676,
                                                longitude: -85.77244171716885)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 80, length: 5280, turn_to_finish_length: 1234, turn_distance: 1292, banking: 3
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 80, length: 4620, turn_to_finish_length: 1080, turn_distance: 1130,
      banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 80, length: 4620, turn_to_finish_length: 1080,
      turn_distance: 1130, banking: 4, jumps: 5
    )

    del_mar = Location.find_or_create_by(name: "Del Mar, CA", state: "California", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Del Mar", location: del_mar, latitude: 32.97584488996692,
                                                longitude: -117.26137280194155)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 80, length: 5280, turn_to_finish_length: 919, turn_distance: 1002, banking: 6
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 63, length: 4620, turn_to_finish_length: 761, turn_distance: 820,
      banking: 7
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 64, length: 4620, turn_to_finish_length: 762,
      turn_distance: 820, banking: 7, jumps: 8
    )

    gulfstream = Location.find_or_create_by(name: "Hallandale Beach, FL", state: "Florida", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Gulfstream", location: gulfstream, latitude: 25.978296858838124,
                                                longitude: -80.13959415974179)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 80, length: 5280, turn_to_finish_length: 952, turn_distance: 1320, banking: 2
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 70, length: 4620, turn_to_finish_length: 921, turn_distance: 1055,
      banking: 2
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 70, length: 4620, turn_to_finish_length: 921,
      turn_distance: 1055, banking: 2, jumps: 6
    )

    santa_anita = Location.find_or_create_by(name: "Arcadia, CA", state: "California", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Santa Anita", location: santa_anita, latitude: 34.13943486041334,
                                                longitude: -118.04526764424672)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 80, length: 5280, turn_to_finish_length: 990, turn_distance: 1159, banking: 3
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 70, length: 4620, turn_to_finish_length: 867, turn_distance: 1100,
      banking: 3
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 70, length: 4620, turn_to_finish_length: 867,
      turn_distance: 1100, banking: 3, jumps: 7
    )

    fort_erie = Location.find_or_create_by(name: "Fort Erie, ON", state: "Ontario", country: "Canada")
    track = Racing::Racetrack.find_or_create_by(name: "Fort Erie", location: fort_erie, latitude: 42.91719773636638,
                                                longitude: -78.93430161520584)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 75, length: 5280, turn_to_finish_length: 1060, turn_distance: 920, banking: 2
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 70, length: 4620, turn_to_finish_length: 930, turn_distance: 950,
      banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 70, length: 4620, turn_to_finish_length: 1060,
      turn_distance: 930, banking: 4, jumps: 8
    )

    pimlico = Location.find_or_create_by(name: "Baltimore, MD", state: "Maryland", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Pimlico", location: pimlico, latitude: 39.35239671481957,
                                                longitude: -76.67455350364794)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 70, length: 5280, turn_to_finish_length: 1162, turn_distance: 1119, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 65, length: 4620, turn_to_finish_length: 1162, turn_distance: 1062,
      banking: 3
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 65, length: 4620, turn_to_finish_length: 1162,
      turn_distance: 1062, banking: 3, jumps: 6
    )

    saratoga = Location.find_or_create_by(name: "Saratoga Springs, NY", state: "New York", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Saratoga", location: saratoga, latitude: 43.07417424394634,
                                                longitude: -73.76801208821416)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 85, length: 5940, turn_to_finish_length: 1144, turn_distance: 1292, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 80, length: 5378, turn_to_finish_length: 1144, turn_distance: 1066,
      banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 65, length: 3960, turn_to_finish_length: 650,
      turn_distance: 990, banking: 4, jumps: 5
    )

    woodbine = Location.find_or_create_by(name: "Etobicoke, ON", state: "Ontario", country: "Canada")
    track = Racing::Racetrack.find_or_create_by(name: "Woodbine", location: woodbine, latitude: 43.71462041867901,
                                                longitude: -79.60417244586846)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 85, length: 5280, turn_to_finish_length: 975, turn_distance: 1335, banking: 6
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 100, length: 5940, turn_to_finish_length: 800, turn_distance: 2005,
      banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 100, length: 5940, turn_to_finish_length: 800,
      turn_distance: 2005, banking: 4, jumps: 8
    )

    calder = Location.find_or_create_by(name: "Miami Gardens, FL", state: "Florida", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Calder", location: calder, latitude: 25.967445634496652,
                                                longitude: -80.24275048672962)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 80, length: 5280, turn_to_finish_length: 990, turn_distance: 1436, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 67, length: 4620, turn_to_finish_length: 986, turn_distance: 1332,
      banking: 5
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 67, length: 4620, turn_to_finish_length: 986,
      turn_distance: 1322, banking: 5, jumps: 5
    )

    lone_star = Location.find_or_create_by(name: "Grand Prairie, TX", state: "Texas", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Lone Star Park", location: lone_star, latitude: 32.77226468229383,
                                                longitude: -96.9886994019458)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 90, length: 5280, turn_to_finish_length: 930, turn_distance: 1300, banking: 6
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 80, length: 4620, turn_to_finish_length: 900, turn_distance: 1020,
      banking: 6
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 80, length: 4620, turn_to_finish_length: 900,
      turn_distance: 1020, banking: 6, jumps: 5
    )

    australia = Location.find_or_create_by(name: "Flemington, VIC", state: "Victoria", country: "Australia")
    track = Racing::Racetrack.find_or_create_by(name: "Australia", location: australia, latitude: -37.79077497446637,
                                                longitude: 144.9118480828217)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 98, length: 7296, turn_to_finish_length: 1312, turn_distance: 1200, banking: 2
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 98, length: 7296, turn_to_finish_length: 1312, turn_distance: 1200,
      banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 62, length: 5905, turn_to_finish_length: 1312,
      turn_distance: 1200, banking: 4, jumps: 15
    )

    dubai = Location.find_or_create_by(name: "Nad Al Sheba", country: "UAE")
    track = Racing::Racetrack.find_or_create_by(name: "Dubai", location: dubai, latitude: 25.159249825824272,
                                                longitude: 55.301946411409446)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 66, length: 7218, turn_to_finish_length: 1968, turn_distance: 1548, banking: 2
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 66, length: 7218, turn_to_finish_length: 1968, turn_distance: 1548,
      banking: 4
    )

    england = Location.find_or_create_by(name: "Epsom", state: "Surrey", country: "England")
    track = Racing::Racetrack.find_or_create_by(name: "England", location: england, latitude: 51.38085777036567,
                                                longitude: -0.2770522107837388)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 80, length: 10_560, turn_to_finish_length: 1980, turn_distance: 2310, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 80, length: 10_560, turn_to_finish_length: 1980, turn_distance: 2310,
      banking: 5
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 80, length: 10_560, turn_to_finish_length: 1980,
      turn_distance: 2310, banking: 5, jumps: 10
    )

    ireland = Location.find_or_create_by(name: "Loughbrown", state: "Kildare", country: "Ireland")
    track = Racing::Racetrack.find_or_create_by(name: "Ireland", location: ireland, latitude: 53.16852191180491,
                                                longitude: -6.843204036496443)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 80, length: 10_560, turn_to_finish_length: 1980, turn_distance: 2310, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 80, length: 10_560, turn_to_finish_length: 1980, turn_distance: 2310,
      banking: 5
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 80, length: 10_560, turn_to_finish_length: 1980,
      turn_distance: 2310, banking: 5, jumps: 10
    )

    hong_kong = Location.find_or_create_by(name: "Sha Tin", county: "Hong Kong", country: "China")
    track = Racing::Racetrack.find_or_create_by(name: "Hong Kong", location: hong_kong, latitude: 22.406066419054742,
                                                longitude: 114.20210443057607)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 66, length: 7218, turn_to_finish_length: 1968, turn_distance: 1548,
      banking: 4
    )

    japan = Location.find_or_create_by(name: "Tokyo", country: "Japan")
    track = Racing::Racetrack.find_or_create_by(name: "Japan", location: japan, latitude: 35.66268118640489,
                                                longitude: 139.48578704050234)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 66, length: 7218, turn_to_finish_length: 1968, turn_distance: 1548, banking: 2
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 66, length: 7218, turn_to_finish_length: 1968, turn_distance: 1548,
      banking: 4
    )

    france = Location.find_or_create_by(name: "Paris", country: "France")
    track = Racing::Racetrack.find_or_create_by(name: "France", location: france, latitude: 48.858952587447526,
                                                longitude: 2.229643527283667)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 66, length: 8202, turn_to_finish_length: 1968, turn_distance: 2312, banking: 4
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 80, length: 8202, turn_to_finish_length: 1968, turn_distance: 2132,
      banking: 4
    )

    ff = Location.find_or_create_by(name: "Final Furlong", country: "USA")
    track = Racing::Racetrack.find_or_create_by(name: "Final Furlong", location: ff, latitude: 38.047171353962845,
                                                longitude: -84.60626185950164)
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, width: 0, length: 0, turn_to_finish_length: 0, turn_distance: 0, banking: 0
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "turf", width: 0, length: 0, turn_to_finish_length: 0, turn_distance: 0,
      banking: 0
    )
    Racing::TrackSurface.find_or_create_by(
      racetrack: track, surface: "steeplechase", width: 0, length: 0, turn_to_finish_length: 0,
      turn_distance: 0, banking: 0, jumps: 5
    )
  end
end

