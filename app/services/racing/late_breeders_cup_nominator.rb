module Racing
  class LateBreedersCupNominator
    attr_reader :horse

    def create_nomination(horse:, stable:)
      result = Result.new

      if horse.breeders_cup_nomination
        result.error = error("horse_already_nominated")
        return result
      end

      if !horse.racehorse?
        result.error = error("horse_not_racehorse")
        return result
      end

      if horse.manager != stable
        result.error = error("stable_not_manager")
        return result
      end

      nomination = horse.build_breeders_cup_nomination(effective_year: Date.current.year + 1)
      fee = if horse.sire.stud_nominations.exists?(year: horse.date_of_birth.year)
        Config::Racing.breeders_cup_nomination_fee_nominated_stud
      else
        Config::Racing.breeders_cup_nomination_fee_unnominated_stud
      end

      if fee > stable.available_balance
        result.error = error("cannot_afford_fee")
        return result
      end

      ActiveRecord::Base.transaction do
        description = I18n.t("services.late_breeders_cup_nominator.budget_description", year: nomination.effective_year, name: horse.name)
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
      I18n.t("services.late_breeders_cup_nominator.#{key}")
    end
  end
end

