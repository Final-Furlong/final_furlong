class Daily::ProcessFutureShipmentsJob < ApplicationJob
  queue_as :low_priority

  def perform
    today = Date.current
    Shipping::BroodmareShipments.where(departure_date: today).find_each do |shipment|
      Horses::Horse::Broodmare::FutureShipmentCreator.new.ship_horse(shipment:)
    end
    Shipping::RacehorseShipments.where(departure_date: today).find_each do |shipment|
      Horses::Horse::Racing::FutureShipmentCreator.new.ship_horse(shipment:)
    end
    outcome = { scheduled: true, broodmare_count: 0, racehorse_count: 0 }
    store_job_info(outcome:)
  end
end

