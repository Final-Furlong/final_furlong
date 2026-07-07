class Racing::PreRace::ShippingJob < ApplicationJob
  queue_as :latency_5m

  retry_on ActiveRecord::RecordInvalid

  def perform
    horses = 0
    date = Racing::RaceSchedule.future.minimum(:date)

    Racing::RaceEntry.where(date:).includes(:horse).find_each do |entry|
      horse = entry.horse
      next if horse.manager.name == Config::Game.stable

      shipment = horse.shipments.order(arrival_date: :desc).first
      shipment&.strict_loading!(false)
      next if shipment&.shipping_type&.ends_with?("to_track") && shipment&.ending_location == entry.race.racetrack.location

      create_shipment(horse:, min_date: shipment&.arrival_date, start_date: entry.created_at.to_date, race: entry.race, last_shipment: shipment)
      horses += 1
    end
    store_job_info(outcome: { horses: })
  end

  private

  def create_shipment(horse:, min_date:, start_date:, race:, last_shipment:)
    arrival_date = race.date - 1.day
    shipment = Horses::Racehorse::Shipment.new(
      horse:,
      starting_location: shipment&.ending_location || horse.manager.racetrack.location,
      ending_location: race.racetrack.location,
      arrival_date:
    )
    route = lookup_route(shipment, horse.manager)
    max_days = (arrival_date - [start_date, min_date].compact_blank.max).to_i
    if route.road_days.to_i.positive? && route.road_days.to_i <= max_days
      shipment.mode = "road"
      shipment.departure_date = arrival_date - route.road_days.days
      cost = route.road_cost
    else
      shipment.mode = "air"
      shipment.departure_date = arrival_date - route.air_days.days
      cost = route.air_cost
    end
    shipment.shipping_type = if last_shipment.blank? || last_shipment.shipping_type.ends_with?("farm")
      "farm_to_track"
    else
      "track_to_track"
    end
    shipment.scheduled = false
    current_location_name = horse.racehorse_metadata.location.name
    ActiveRecord::Base.transaction do
      shipment.save!
      horse.racehorse_metadata&.update(in_transit: false, location_string: race.racetrack.name, location: shipment.ending_location, racetrack: race.racetrack)
      description = I18n.t("services.shipment_creator.description", horse: horse.name, start: current_location_name, end: race.racetrack.name)
      Accounts::BudgetTransactionCreator.new.create_transaction(stable: horse.manager, description:, amount: cost.abs * -1)
    end
  end

  def lookup_route(shipment, stable)
    if shipment.starting_location == shipment.ending_location
      Shipping::Route.new(miles: stable.miles_from_track, road_days: 1, road_cost: 25)
    else
      Shipping::Route.find_by(starting_location: shipment.starting_location,
        ending_location: shipment.ending_location)
    end
  end
end

