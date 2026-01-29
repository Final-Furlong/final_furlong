class MigrateLegacyShipmentsService
  def call
    Horses::Horse.select(:id, :legacy_id, :status).where(status: %w[broodmare racehorse])
      .find_in_batches(batch_size: 100) do |horses|
      horses.each do |info|
        if info[:status] == "racehorse"
          shipment_count = Shipping::RacehorseShipment.where(horse_id: info.id).count
          legacy_count = Legacy::HorseShipping.where(Horse: info.legacy_id).count
        else
          Shipping::RacehorseShipment.where(horse_id: info.id).delete_all
          shipment_count = Shipping::BroodmareShipment.where(horse_id: info.id).count
          legacy_count = Legacy::HorseShipping.where(Horse: info.legacy_id).where("FromFarm IS NOT NULL AND ToFarm IS NOT NULL").count
        end

        if legacy_count > shipment_count
          MigrateLegacyShipmentService.new.call(info)
        end
      end
    end
  end
end

