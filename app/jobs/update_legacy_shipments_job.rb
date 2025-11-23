class UpdateLegacyShipmentsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Horses::Horse.racehorse.find_each do |horse|
      UpdateLegacyShipmentJob.perform_later(horse.legacy_id)
    end
    Horses::Horse.broodmare.find_each do |horse|
      UpdateLegacyShipmentJob.perform_later(horse.legacy_id)
    end
  end
end

