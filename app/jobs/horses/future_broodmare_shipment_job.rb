class Horses::FutureBroodmareShipmentJob < ApplicationJob
  def perform(id:, date:)
    shipment = Horses::Broodmare::Shipment.scheduled.where(departure_date: date).find_by(id:)
    return unless shipment

    Horses::Broodmare::FutureShipmentProcessor.new.ship_horse(shipment:)
  end
end

