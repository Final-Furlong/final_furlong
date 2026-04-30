class Horses::FutureBroodmareShipmentJob < ApplicationJob
  def perform(id:, date:)
    shipment = Shipping::BroodmareShipment.scheduled.where(departure_date: date).find_by(id:)
    Horses::Broodmare::FutureShipmentProcessor.new.ship_horse(shipment:)
  end
end

