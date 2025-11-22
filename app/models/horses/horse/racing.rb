class Horses::Horse::Racing < ActiveRecord::AssociatedObject
  record.has_one :race_options, class_name: "Racing::RaceOption", dependent: :delete
  record.has_one :race_stats, class_name: "Racing::RaceStats", dependent: :delete

  def current_location
    pd last_shipment
    current_location = case last_shipment.shipping_type
    when "track_to_track", "farm_to_track"
      Racing::Racetrack.find_by(location: last_shipment.ending_location)
    when "track_to_farm"
      record.manager
    end
    # current_location ||=
    pd current_location
    current_location
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

  def current_location_name
    case last_shipment.shipping_type
    when "track_to_track", "farm_to_track"
      name = Racing::Racetrack.where(location: last_shipment.ending_location).pick(:name)
      I18n.t("horse.location.at_racetrack", name:)
    when "track_to_farm"
      record.manager.name
    end
  end

  def last_shipment
    record.racing_shipments.order(arrival_date: :desc).first
  end
end

