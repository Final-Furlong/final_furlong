module Horses
  class AutoSaleOffersUpdater
    def call
      offered_sales = 0
      Horses::SaleOffer.with_buyer.starts_today.includes(:horse, buyer: :user).find_each do |offer|
        horse = offer.horse
        ActiveRecord::Base.transaction do
          Game::NotificationCreator.new.create_notification(
            type: ::SaleOfferNotification,
            user: offer.buyer.user,
            params: {
              offer_id: offer.id,
              horse_id: horse.slug,
              horse_name: horse.name,
              stable_name: horse.owner.name,
              price: Game::MoneyFormatter.new(offer.price).to_s
            }
          )
        end
        offered_sales += 1
      end
      expired_offers = 0
      Horses::SaleOffer.expired.includes(:horse).find_each do |offer|
        horse = offer.horse
        ActiveRecord::Base.transaction do
          Game::NotificationCreator.new.create_notification(
            type: ::SaleOfferExpiryNotification,
            user: offer.owner.user,
            params: {
              offer_id: offer.id,
              horse_id: horse.slug,
              horse_name: horse.name,
              price: offer.price
            }
          )
          offer.destroy!
        end
        expired_offers += 1
      end
      { offered_sales:, expired_offers: }
    end
  end
end

