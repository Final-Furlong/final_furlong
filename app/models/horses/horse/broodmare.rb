class Horses::Horse::Broodmare < ActiveRecord::AssociatedObject
  record.has_one :broodmare_foal_record, inverse_of: :mare, dependent: :delete

  def breed_ranking_string
    record.broodmare_foal_record&.breed_ranking_string
  end

  def current_location
    if last_shipment.nil?
      record.manager
    else
      last_shipment.ending_farm
    end
  end

  def current_location_name
    return record.manager.name if last_shipment.nil?

    last_shipment.ending_farm.name
  end

  def in_transit?
    return false if last_shipment.nil?

    last_shipment.arrival_date > Date.current
  end

  def last_shipment
    record.broodmare_shipments.current.order(arrival_date: :desc).first
  end
end

