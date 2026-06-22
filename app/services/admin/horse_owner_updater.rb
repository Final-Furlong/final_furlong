module Admin
  class HorseOwnerUpdater
    attr_reader :horse

    def update_owner(horse:, stable_id:)
      result = Result.new(horse:)
      new_owner = Account::Stable.find_by(id: stable_id)

      recent_sale = horse.sales.includes(:buyer).order(date: :desc).first
      if recent_sale&.buyer != new_owner
        sale = ::Horses::Sale.new(
          horse:,
          seller: horse.owner,
          buyer: new_owner,
          date: Date.current,
          price: 0,
          private: true
        )
      end
      ActiveRecord::Base.transaction do
        if sale.blank? || (sale.valid? && sale.save)
          if sale
            price = ::Game::MoneyFormatter.new(sale.price).to_s
            description = I18n.t("services.sale_creator.description_seller", horse: horse.name, stable: new_owner.name, price:)
            ::Accounts::BudgetTransactionCreator.new.create_transaction(stable: horse.owner, description:, amount: 0)
            description = I18n.t("services.sale_creator.description_buyer", horse: horse.name, stable: horse.owner.name, price:)
            ::Accounts::BudgetTransactionCreator.new.create_transaction(stable: new_owner, description:, amount: 0)
          end

          horse.update(owner: new_owner, manager: new_owner)
          if horse.racehorse?
            horse.training_schedules_horse&.destroy
            horse.race_entries.each do |entry|
              entry.claims.each do |claim|
                claim.destroy
              end
              entry.destroy
            end
            unless horse.current_boarding
              last_shipment = horse.racing_shipments.order(arrival_date: :desc).first
              if last_shipment&.shipping_type == "track_to_farm"
                racetrack = new_owner.racetrack
                horse.race_metadata&.update(racetrack:, location: racetrack.location, location_string: new_owner.name)
              end
            end
          end
          ::Horses::Horse.unborn.where(dam: horse).find_each do |foal|
            foal.update(owner: new_owner, manager: new_owner)
          end

          result.saved = true
        else
          result.saved = false
          result.error = horse.errors.full_messages.to_sentence
        end
        result.sale = sale
      end
      result
    end

    class Result
      attr_accessor :error, :saved, :sale

      def initialize(horse:, saved: false, error: nil)
        @saved = saved
        @horse = horse
        @sale = nil
        @error = nil
      end

      def saved?
        @saved
      end
    end
  end
end

