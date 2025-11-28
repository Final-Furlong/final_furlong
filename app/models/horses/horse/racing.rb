class Horses::Horse::Racing < ActiveRecord::AssociatedObject
  record.has_one :race_options, class_name: "Racing::RaceOption", dependent: :delete
  record.has_one :racing_stats, class_name: "Racing::RacingStats", dependent: :delete

  def current_location
    if last_shipment.nil?
      record.manager.racetrack.location
    else
      last_shipment.ending_location
    end
  end

  def at_farm?
    return true if last_shipment.nil?

    case last_shipment.shipping_type
    when "track_to_track", "farm_to_track"
      false
    when "track_to_farm"
      true
    end
  end

  def in_transit?
    return false if last_shipment.nil?

    last_shipment.arrival_date > Date.current
  end

  def current_location_name
    if last_shipment.nil?
      return record.manager.name
    end

    case last_shipment.shipping_type
    when "track_to_track", "farm_to_track"
      name = Racing::Racetrack.where(location: last_shipment.ending_location).pick(:name)
      I18n.t("horse.location.at_racetrack", name:)
    when "track_to_farm"
      record.manager.name
    end
  end

  def last_shipment
    record.racing_shipments.not_future.order(arrival_date: :desc).first
  end
end

