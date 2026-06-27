class Horses::FutureRaceEntryShipmentJob < ApplicationJob
  def perform(id:, date:)
    entry = Racing::FutureRaceEntry.find_by(id:)
    return unless entry

    race = entry.race
    horse = entry.horse
    race_location = race.racetrack.location
    horse_location = horse.race_metadata.location
    return if race_location == horse_location

    route = Shipping::Route.with_locations(race_location, horse_location).first
    shipment = Horses::Racehorse::Shipment.new(
      horse: entry.horse, departure_date: date, scheduled: true, starting_location: horse_location, ending_location: race_location
    )
    max_travel_days = (race.travel_deadline - date).to_i
    if (entry.ship_mode.blank? || entry.ship_mode.road?) && route.road_days && route.road_days < max_travel_days
      shipment.mode = "road"
      days = route.road_days
    end
    if (entry.ship_mode.blank? || entry.ship_mode.air?) && route.air_days && route.air_days < max_travel_days
      shipment.mode = "air" if shipment.mode.blank?
      days = route.air_days
    end
    shipment.arrival_date = date + days.days
    shipment.shipping_type = horse.race_metadata.at_home? ? "farm_to_track" : "track_to_track"
    Horses::Racehorse::FutureShipmentProcessor.new.ship_horse(shipment:)
  end
end

