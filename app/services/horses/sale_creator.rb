module Horses
  class SaleCreator
    attr_reader :offer

    def accept_offer(horse:, stable:)
      offer = horse.sale_offer
      result = Result.new(horse:)
      unless offer
        result.error = i18n("not_for_sale")
        return result
      end

      available_balance = stable.available_balance
      if available_balance.nil? || available_balance < offer.price
        result.error = i18n("cannot_afford_purchase")
        return result
      end

      sale = Horses::Sale.new(
        horse:,
        seller: horse.owner,
        buyer: stable,
        date: Date.current,
        price: offer.price,
        private: true
      )
      ActiveRecord::Base.transaction do
        if sale.valid? && sale.save
          horse.update(owner: stable)
          legacy_horse = Legacy::Horse.find_by(ID: horse.legacy_id)
          legacy_horse&.update(Owner: stable.legacy_id)
          Legacy::ViewRacehorses.find_by(horse_id: horse.legacy_id)&.update(owner: stable.legacy_id)
          Legacy::ViewTrainingSchedules.find_by(horse_id: horse.legacy_id)&.update(owner: stable.legacy_id)
          price = Game::MoneyFormatter.new(sale.price).to_s
          description = I18n.t("services.sale_creator.description_buyer", horse: horse.name, stable: horse.owner.name, price:)
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: sale.price.abs * -1)
          description = I18n.t("services.sale_creator.description_seller", horse: horse.name, stable: stable.name, price:)
          Accounts::BudgetTransactionCreator.new.create_transaction(stable: horse.owner, description:, amount: sale.price.abs)

          ::SaleAcceptanceNotification.create!(
            user: horse.owner.user,
            params: {
              horse_id: horse.slug,
              horse_name: horse.name,
              stable_name: stable.name,
              price:
            }
          )
          SaleOfferNotification.param_equals(:offer_id, offer.id).delete_all
          offer.destroy!
          result.created = true
        else
          result.created = false
          result.error = sale.errors.full_messages.to_sentence
        end
        result.sale = sale
      end
      result
    end

    class Result
      attr_accessor :error, :created, :sale

      def initialize(horse:, created: false, error: nil)
        @created = created
        @horse = horse
        @sale = nil
        @error = nil
      end

      def created?
        @created
      end
    end

    def i18n(key)
      I18n.t("services.sale_creator.#{key}")
    end
  end
end

