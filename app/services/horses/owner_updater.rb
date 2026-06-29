module Horses
  class OwnerUpdater
    attr_reader :horse

    def transfer_to_game(horse:, stable:)
      result = Result.new(horse:)
      game_stable = Account::Stable.find_by(name: Config::Game.stable)

      sale = Horses::Sale.new(
        horse:,
        seller: stable,
        buyer: game_stable,
        date: Date.current,
        price: 0,
        private: false
      )
      ActiveRecord::Base.transaction do
        if sale.valid? && sale.save
          price = Game::MoneyFormatter.new(sale.price).to_s
          description = I18n.t("services.sale_creator.description_seller", horse: horse.name, stable: game_stable.name, price:)
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: 0)

          horse.update(owner: game_stable, manager: game_stable)
          horse.training_schedules_horse&.destroy if horse.respond_to?(:training_schedule_horse)
          if horse.respond_to?(:race_entries)
            horse.race_entries.each do |entry|
              entry.claims.each do |claim|
                claim.destroy
              end
              entry.destroy
            end
          end
          Horses::Horse.unborn.where(dam: horse).find_each do |foal|
            foal.update(owner: game_stable, manager: game_stable)
          end

          result.saved = true
        else
          result.saved = false
          result.error = sale.errors.full_messages.to_sentence
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

