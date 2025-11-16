module Horses
  class AutoLeaseOffersUpdater
    def call
      Horses::LeaseOffer.with_leaser.starts_today.includes(:horse, leaser: :user).find_each do |offer|
        horse = offer.horse
        duration = "#{offer.duration_months} #{"month".pluralize(offer.duration_months)}"
        ActiveRecord::Base.transaction do
          Game::NotificationCreator.new.create_notification(
            type: ::LeaseOfferNotification,
            user: offer.leaser.user,
            params: {
              offer_id: offer.id,
              horse_id: horse.slug,
              horse_name: horse.name,
              stable_name: horse.owner.name,
              duration:,
              fee: Game::MoneyFormatter.new(offer.fee).to_s
            }
          )
        end
      end
      Horses::LeaseOffer.expired.includes(:horse).find_each do |offer|
        horse = offer.horse
        duration = "#{offer.duration_months} #{"month".pluralize(offer.duration_months)}"
        ActiveRecord::Base.transaction do
          Game::NotificationCreator.new.create_notification(
            type: ::LeaseOfferExpiryNotification,
            user: offer.owner.user,
            params: {
              offer_id: offer.id,
              horse_id: horse.slug,
              horse_name: horse.name,
              duration:,
              fee: offer.fee
            }
          )
          offer.destroy!
        end
      end
    end
  end
end

