module Horses::Racehorse
  class BreedersCupNominator
    def nominate_horses(horse_ids:, stable:)
      pd horse_ids
      horses = Horses::Horse.managed_by(stable).where(id: horse_ids)
      pd horses
      result = Result.new(horses:, created: false)
      if horse_ids.count != horses.count
        result.error = error("do_not_own_all_horses")
        return result
      end

      single_nomination_fee = Config::Racing.breeders_cup_nomination_fee
      total_fee = horses.count * single_nomination_fee
      if total_fee > stable.available_balance
        result.error = error("cannot_afford_nominations")
        return result
      end

      ActiveRecord::Base.transaction do
        horses.each do |horse|
          next if horse.breeders_cup_nomination

          result.created = Racing::BreedersCupNomination.create(horse:, effective_year: nil)
          description = I18n.t("services.breeders_cup_nominator.budget_description", name: horse.name, year: horse.date_of_birth.year + 2)
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: single_nomination_fee * -1)
        end
      end
      result
    end

    class Result
      attr_reader :horses
      attr_accessor :created, :error

      def initialize(created:, horses:)
        @created = created
        @horses = horses
        @error = nil
      end

      def created?
        @created
      end
    end

    private

    def error(key)
      I18n.t("services.breeders_cup_nominator.#{key}")
    end
  end
end

