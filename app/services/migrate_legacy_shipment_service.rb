class MigrateLegacyShipmentService
  def call(info)
    shipments = if info[:status] == "racehorse"
      Legacy::HorseShipping.where(Horse: info.legacy_id)
    else
      Legacy::HorseShipping.where(Horse: info.legacy_id).where.not(FromFarm: nil, ToFarm: nil)
    end
    shipments.find_each do |legacy_shipment|
      migrate_shipment(legacy_shipment:)
    end
  end

  private

  def migrate_shipment(legacy_shipment:)
    horse = Horses::Horse.find_by(legacy_id: legacy_shipment.Horse)
    return unless horse

    departure_date = legacy_shipment.Date - 4.years
    return if legacy_shipment.Arrive < Date.current - 30.years
    arrival_date = legacy_shipment.Arrive - 4.years
    if legacy_shipment.FromTrack.to_i.positive?
      start_track = Legacy::Racetrack.find(legacy_shipment.FromTrack)
      starting_location = Location.joins(:racetrack).find_by(racetracks: { name: start_track.Name })
    elsif legacy_shipment.FromFarm.to_i.positive?
      stable = Account::Stable.find_by(legacy_id: legacy_shipment.FromFarm)
      starting_location = if legacy_shipment.ToFarm.to_i.positive?
        stable
      else
        Location.joins(:racetrack).find_by(racetrack: stable.racetrack)
      end
    end
    return unless starting_location

    if legacy_shipment.ToTrack.to_i.positive?
      end_track = Legacy::Racetrack.find(legacy_shipment.ToTrack)
      ending_location = Location.joins(:racetrack).find_by(racetracks: { name: end_track.Name })
    elsif legacy_shipment.ToFarm.to_i.positive?
      stable = Account::Stable.find_by(legacy_id: legacy_shipment.ToFarm)
      ending_location = if legacy_shipment.FromFarm.to_i.positive?
        stable
      else
        Location.joins(:racetrack).find_by(racetrack: stable.racetrack)
      end
    end
    return unless ending_location

    class_name = if legacy_shipment.FromFarm.to_i.positive? && legacy_shipment.ToFarm.to_i.positive?
      Shipping::BroodmareShipment
    else
      Shipping::RacehorseShipment
    end
    shipment = class_name.find_or_initialize_by(horse:, departure_date:)
    shipment.arrival_date = arrival_date
    shipment.mode = (legacy_shipment.Mode == "R") ? "road" : "air"
    if class_name == Shipping::BroodmareShipment
      shipment.starting_farm = starting_location
      shipment.ending_farm = ending_location
      return if starting_location == ending_location
    else
      shipment.starting_location = starting_location
      shipment.ending_location = ending_location
      shipment.shipping_type = if legacy_shipment.FromTrack.to_i.positive? && legacy_shipment.ToTrack.to_i.positive?
        "track_to_track"
      elsif legacy_shipment.FromTrack.to_i.positive?
        "track_to_farm"
      elsif legacy_shipment.FromFarm.to_i.positive?
        "farm_to_track"
      end
    end
    shipment.save!
  rescue ActiveRecord::RecordInvalid => e
    raise e
  end
end

