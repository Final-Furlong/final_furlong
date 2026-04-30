class Horses::FutureRacehorseShipmentJob < ApplicationJob
  def perform(id:, date:)
    shipment = Shipping::RacehorseShipment.scheduled.where(departure_date: date).find_by(id:)
    Horses::Racehorse::FutureShipmentProcessor.new.ship_horse(shipment:)
  end
end

