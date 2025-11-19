class UpdateLegacyHorseSalesJob < ApplicationJob
  queue_as :low_priority

  def perform
    min_date = Horses::Sale.maximum(:date) || Date.current - 30.years
    Legacy::HorseSale.where(Date: (min_date + 4.years)..).find_each do |legacy_sale|
      migrate_legacy_sale(legacy_sale:)
    end
  end

  private

  def migrate_legacy_sale(legacy_sale:)
    return if legacy_sale.Price.nil?

    horse = Horses::Horse.find_by(legacy_id: legacy_sale.Horse)
    return unless horse

    seller = Account::Stable.find_by(legacy_id: legacy_sale.Seller)
    return unless seller

    buyer = Account::Stable.find_by(legacy_id: legacy_sale.Buyer)
    return unless buyer
    return if seller == buyer

    date = legacy_sale.Date - 4.years
    sale = Horses::Sale.find_or_initialize_by(horse:, seller:, date:, buyer:)
    sale.assign_attributes(price: legacy_sale.Price, private: legacy_sale.PT)
    sale.save!
  end
end

