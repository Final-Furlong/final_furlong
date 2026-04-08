class Daily::ProcessFutureShipmentsJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    today = Date.current
    unless run_today?
      broodmare_count = 0
      step :broodmares do |step|
        Shipping::BroodmareShipment.scheduled.where(departure_date: today).find_each(start: step.cursor) do |shipment|
          Horses::Broodmare::FutureShipmentProcessor.new.ship_horse(shipment:)
          broodmare_count += 1
          step.advance! from: shipment.id
        end
      end
    end

    racehorse_count = 0
    step :racehorses do |step|
      Shipping::RacehorseShipment.scheduled.where(departure_date: today).find_each(start: step.cursor) do |shipment|
        Horses::Racing::FutureShipmentProcessor.new.ship_horse(shipment:)
        racehorse_count += 1
        step.advance! from: shipment.id
      end
    end

    step :racehorse_future_entries do |step|
      today = Date.current
      Racing::FutureRaceEntry.where(ship_date: today, ship_only_if_horse_is_entered: false).find_each(start: step.cursor) do |entry|
        race = entry.race
        horse = entry.horse
        race_location = race.racetrack.location
        horse_location = horse.race_metadata.location
        next if race_location == horse_location

        route = Shipping::Route.with_locations(race_location, horse_location).first
        shipment = Shipping::RacehorseShipment.new(
          horse: entry.horse, departure_date: today, scheduled: true, starting_location: horse_location, ending_location: race_location
        )
        max_travel_days = (race.travel_deadline - today).to_i
        if (entry.ship_mode.blank? || entry.ship_mode.road?) && route.road_days && route.road_days < max_travel_days
          shipment.mode = "road"
          days = route.road_days
        end
        if (entry.ship_mode.blank? || entry.ship_mode.air?) && route.air_days && route.air_days < max_travel_days
          shipment.mode = "air" if shipment.mode.blank?
          days = route.air_days
        end
        shipment.arrival_date = today + days.days
        shipment.shipping_type = horse.race_metadata.at_home? ? "farm_to_track" : "track_to_track"
        Horses::Racing::FutureShipmentProcessor.new.ship_horse(shipment:)
        racehorse_count += 1
        step.advance! from: entry.id
      end
    end

    step :racehorse_future_entries_opening_day do |step|
      today = Date.current
      today.strftime("%A").downcase
      return unless %w[tuesday friday].include?("weekday")

      Racing::FutureRaceEntry.where(ship_when_entries_open: true, ship_only_if_horse_is_entered: false).find_each(start: step.cursor) do |entry|
        race = entry.race
        horse = entry.horse
        race_location = race.racetrack.location
        horse_location = horse.race_metadata.location
        next if race_location == horse_location

        route = Shipping::Route.with_locations(race_location, horse_location).first
        shipment = Shipping::RacehorseShipment.new(
          horse: entry.horse, departure_date: today, scheduled: true, starting_location: horse_location, ending_location: race_location
        )
        max_travel_days = (race.travel_deadline - today).to_i
        if (entry.ship_mode.blank? || entry.ship_mode.road?) && route.road_days && route.road_days < max_travel_days
          shipment.mode = "road"
          days = route.road_days
        end
        if (entry.ship_mode.blank? || entry.ship_mode.air?) && route.air_days && route.air_days < max_travel_days
          shipment.mode = "air" if shipment.mode.blank?
          days = route.air_days
        end
        shipment.arrival_date = today + days.days
        shipment.shipping_type = horse.race_metadata.at_home? ? "farm_to_track" : "track_to_track"
        Horses::Racing::FutureShipmentProcessor.new.ship_horse(shipment:)
        racehorse_count += 1
        step.advance! from: entry.id
      end
    end
    outcome = { scheduled: true, broodmare_count:, racehorse_count: }
    store_job_info(outcome:)
  end
end

