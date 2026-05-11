module Horses
  class BoardingUpdater < ApplicationService
    def stop_boarding(boarding:)
      result = Result.new(updated: false, boarding:)
      if boarding.end_date
        result.error = error("already_ended")
        return result
      end

      horse = boarding.horse
      stable = horse.manager

      ActiveRecord::Base.transaction do
        boarding.update(end_date: Date.current, days: (Date.current - boarding.start_date).to_i)
        if boarding.days > 0
          days_string = "#{boarding.days} "
          days_string += "day".pluralize(boarding.days)
          description = I18n.t("services.boarding.updater.budget_description", name: horse.name, days: days_string)
          amount = boarding.days * Config::Boarding.daily_fee * -1
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount:)
          racetrack_name = ::Racing::Racetrack.where(location: boarding.location).pick(:name)
          horse.race_metadata&.update(location_string: I18n.t("horse.location.at_racetrack", name: racetrack_name))
          result.boarding = boarding
        else
          boarding.destroy!
        end
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

