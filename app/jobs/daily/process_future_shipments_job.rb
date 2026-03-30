class Daily::ProcessFutureShipmentsJob < ApplicationJob
  queue_as :low_priority

  def perform
    return if run_today?

    today = Date.current
    Shipping::BroodmareShipments.scheduled.where(departure_date: today).find_each do |shipment|
      Horses::Horse::Broodmare::FutureShipmentProcessor.new.ship_horse(shipment:)
    end
    Shipping::RacehorseShipments.scheduled.where(departure_date: today).find_each do |shipment|
      Horses::Horse::Racing::FutureShipmentProcessor.new.ship_horse(shipment:)
    end
    outcome = { scheduled: true, broodmare_count: 0, racehorse_count: 0 }
    store_job_info(outcome:)
  end
end

