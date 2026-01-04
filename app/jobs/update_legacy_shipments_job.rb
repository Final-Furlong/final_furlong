class UpdateLegacyShipmentsJob < ApplicationJob
  queue_as :low_priority

  def perform
    min_date = Shipping::RacehorseShipment.maximum(:departure_date) || Date.current - 30.years
    min_date += 4.years
    racehorses = 0
    Legacy::HorseShipping.joins(:horse).where(horse: { Status: 3 }).where(Date: min_date..).find_each do |legacy_shipment|
      UpdateLegacyShipmentJob.perform_later(legacy_shipment.Horse)
      racehorses += 1
    end
    min_date = Shipping::BroodmareShipment.maximum(:departure_date) || Date.current - 30.years
    min_date += 4.years
    broodmares = 0
    Legacy::HorseShipping.joins(:horse).where(horse: { Status: 1 }).where(Date: min_date..).find_each do |legacy_shipment|
      UpdateLegacyShipmentJob.perform_later(legacy_shipment.Horse)
      broodmares += 1
    end
    store_job_info(outcome: { racehorses:, broodmares: })
  end
end

