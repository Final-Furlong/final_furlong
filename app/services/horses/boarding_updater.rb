module Horses
  class BoardingUpdater < ApplicationService
    def stop_boarding(boarding:)
      result = Result.new(updated: false, boarding:)
      if boarding.end_date
        result.error = error("already_ended")
        return result
      end

      legacy_horse = Legacy::Horse.find_by(ID: boarding.horse.legacy_id)
      stable = if legacy_horse&.Leased
        Account::Stable.find_by(legacy_id: legacy_horse.leaser)
      else
        boarding.horse.owner
      end

      ActiveRecord::Base.transaction do
        boarding.update(end_date: Date.current, days: (Date.current - boarding.start_date).to_i)
        if boarding.days > 0
          days_string = "#{boarding.days} "
          days_string += "day".pluralize(boarding.days)
          description = I18n.t("services.boarding.updater.budget_description", name: boarding.horse.name, days: days_string)
          amount = boarding.days * Config::Boarding.daily_fee * -1
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount:)
          result.boarding = boarding
        else
          boarding.destroy!
        end
        legacy_horse&.update(boarding_id: nil)
        result.updated = true
      rescue ActiveRecord::ActiveRecordError => e
        result.updated = false
        result.error = e.message
      end
      result
    end

    class Result
      attr_accessor :updated, :boarding, :error

      def initialize(updated:, boarding:)
        @updated = updated
        @boarding = boarding
        @error = nil
      end

      def updated?
        @updated
      end
    end

    private

    def error(key)
      I18n.t("services.boarding.updater.#{key}")
    end
  end
end

