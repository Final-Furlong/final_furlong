class Shipping::ProcessArrivalsJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    min_date = (last_run&.to_date || Date.current) - 1.day

    Shipping::RacehorseShipment.where("arrival_date > ? AND arrival_date <= ?", min_date, Date.current).find_each do |shipment|
      horse = shipment.horse
      next unless (date = horse.race_metadata)

      racetrack = Racing::Racetrack.find_by(location: shipment.location)

      attrs = { in_transit: false, last_shipped_at: shipment.arrival_date, location: shipment.location, racetrack:, at_home: shipment.shipment_type == "track_to_farm" }
      attrs[:last_shipped_home_at] = shipment.arrival_date if shipment.shipment_type == "track_to_farm"

      date.update(attrs)
    end
  end
end

