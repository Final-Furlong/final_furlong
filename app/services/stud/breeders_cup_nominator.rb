module Stud
  class BreedersCupNominator
    attr_reader :horse

    def create_nomination(horse:, stable:)
      result = Result.new

      if horse.stud_nominations.exists?(year: Date.current.year + 1)
        result.error = error("horse_already_nominated")
        return result
      end

      if !horse.stud?
        result.error = error("horse_not_stud")
        return result
      end

      if horse.manager_id != stable.id
        result.error = error("stable_not_manager")
        return result
      end

      nomination = horse.stud_nominations.build(year: Date.current.year + 1)
      fee = Config::Racing.breeders_cup_nomination_fee_stud

      if fee > stable.available_balance
        result.error = error("cannot_afford_fee")
        return result
      end

      ActiveRecord::Base.transaction do
        description = I18n.t("services.stud_breeders_cup_nominator.budget_description", year: nomination.year, name: horse.name)
        Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: fee * -1)
        result.created = nomination.save
      end
      result
    end

    class Result
      attr_accessor :created, :error

      def initialize(created: false, error: nil)
        @created = created
        @error = error
      end

      def created?
        @created
      end
    end

    private

    def error(key)
      I18n.t("services.stud_breeders_cup_nominator.#{key}")
    end
  end
end

