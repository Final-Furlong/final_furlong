class Shipping::ProcessArrivalsJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    min_date = (last_run&.to_date || Date.current) - 1.day

    horses = 0
    Shipping::RacehorseShipment.where("arrival_date > ? AND arrival_date <= ?", min_date, Date.current).find_each do |shipment|
      horse = shipment.horse
      next unless (date = horse.race_metadata)

      racetrack = Racing::Racetrack.find_by(location: shipment.ending_location)

      date.update(
        in_transit: false,
        last_shipped_at: shipment.arrival_date,
        location: shipment.ending_location,
        racetrack:,
        at_home: shipment.shipping_type == "track_to_farm"
      )
      Legacy::Horse.where(ID: horse.legacy_id).update(InTransit: 0)
      horses += 1
    end
    Shipping::BroodmareShipment.where("arrival_date > ? AND arrival_date <= ?", min_date, Date.current).find_each do |shipment|
      horse = shipment.horse

      Legacy::Horse.where(ID: horse.legacy_id).update(InTransit: 0)
      horses += 1
    end
    store_job_info(outcome: { horses:, date: min_date })
  end
end

