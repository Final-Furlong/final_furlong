module Racing
  class SupplementalBreedersCupNominator
    attr_reader :horse

    def create_nomination(horse:, stable:, race:)
      result = Result.new

      if (bc_nom = horse.breeders_cup_nomination)
        if bc_nom.effective_year.blank? || bc_nom.effective_year <= Date.current.year
          result.error = error("horse_already_nominated")
          return result
        end
      end

      if horse.supplemental_breeders_cup_nomination
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

      nomination = horse.build_supplemental_breeders_cup_nomination(year: Date.current.year, race:)
      fee = (race.purse * Config::Racing.breeders_cup_nomination_fee_supplemental_percent).to_i

      if fee > stable.available_balance
        result.error = error("cannot_afford_fee")
        return result
      end

      ActiveRecord::Base.transaction do
        description = I18n.t("services.supplemental_breeders_cup_nominator.budget_description", year: nomination.year, race: race.name, name: horse.name)
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
      I18n.t("services.supplemental_breeders_cup_nominator.#{key}")
    end
  end
end

