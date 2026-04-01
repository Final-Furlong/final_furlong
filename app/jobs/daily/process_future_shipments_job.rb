class Daily::ProcessFutureShipmentsJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    today = Date.current
    unless run_today?
      broodmare_count = 0
      step :broodmares do |step|
        Shipping::BroodmareShipment.scheduled.where(departure_date: today).find_each(start: step.cursor) do |shipment|
          Horses::Broodmare::FutureShipmentProcessor.new.ship_horse(shipment:)
          broodmare_count += 1
          step.advance! from: shipment.id
        end
      end
    end

    racehorse_count = 0
    step :racehorses do |step|
      Shipping::RacehorseShipment.scheduled.where(departure_date: today).find_each(start: step.cursor) do |shipment|
        Horses::Racing::FutureShipmentProcessor.new.ship_horse(shipment:)
        racehorse_count += 1
        step.advance! from: shipment.id
      end
    end
    outcome = { scheduled: true, broodmare_count:, racehorse_count: }
    store_job_info(outcome:)
  end
end

