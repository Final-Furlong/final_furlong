module Racing
  class EntryScratcher
    attr_reader :entry, :race, :stable, :horse

    def scratch_entry(entry:, stable:)
      @entry = entry
      @race = entry.race
      @stable = stable
      @horse = entry.horse
      result = Result.new(entry:)
      unless Racing::RaceEntryPolicy.new(stable.user, entry).scratch?
        result.error = error("cannot_scratch")
      end
      refund = race.entry_deadline >= Date.current
      result.message = I18n.t("services.races.entry_scratcher.scratch_without_refund", name: horse.name)

      ActiveRecord::Base.transaction do
        if refund
          description = I18n.t("racing.entry_options.budget_description", date: race.date, number: race.number, name: horse.name)
          budget = Account::Budget.find_by(stable:, description:)
          if budget
            Account::Budget.where(stable:).where("id > ?", budget.id).find_each do |row|
              row.update(balance: row.balance + budget.amount.to_i.abs)
            end
            budget.destroy!
            result.message = I18n.t("services.races.entry_scratcher.scratch_with_refund", name: horse.name)
          end
        end
        result.scratched = entry.destroy!
      end
      result
    end

    class Result
      attr_accessor :entry, :scratched, :error, :message

      def initialize(entry:, scratched: false, error: nil, message: nil)
        @entry = entry
        @scratched = scratched
        @error = error
        @message = nil
      end

      def scratched?
        @scratched
      end
    end

    private

    def error(key)
      I18n.t("services.races.entry_scratcher.#{key}")
    end
  end
end

