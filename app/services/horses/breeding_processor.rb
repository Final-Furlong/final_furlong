module Horses
  class BreedingProcessor < ApplicationService
    attr_reader :breeding, :mare, :stud

    def do_breeding(breeding:, mare:, stud:)
      @breeding = breeding
      @mare = mare
      @stud = stud
      breeding.stud = stud

      result = Result.new(breeding:)
      if breeding.status == "bred"
        result.error = error("mare_already_bred")
        return result
      elsif breeding.status == "denied"
        result.error = error("mare_not_eligible")
        return result
      end

      if breeding.mare_id != mare.id && !breeding.open_booking?
        result.error = error("mare_not_eligible")
        return result
      elsif breeding.open_booking?
        breeding.mare = mare
        breeding.open_booking = false
      end

      if breeding.stable != mare.manager
        result.error = error("mare_not_eligible")
        return result
      end

      if breeding.fee >= mare.manager.available_balance.to_i
        result.error = error("cannot_afford_fee")
        return result
      end

      ActiveRecord::Base.transaction do
        description = "Breeding: #{mare.name} to #{stud.name}"
        Accounts::BudgetTransactionCreator.new.create_transaction(stable: mare.manager, description:, amount: breeding.fee.abs * -1, activity_type: "breeding")

        description = "Stud Booking: #{stud.name} & #{mare.name}"
        Accounts::BudgetTransactionCreator.new.create_transaction(stable: stud.manager, description:, amount: breeding.fee.abs, activity_type: "breeding")
        breeding.event = breeding.pick_event
        breeding.status = "bred"
        breeding.due_date = breeding.pick_due_date
        if breeding.save!
          result.updated = true
          result.breeding = breeding
        else
          result.updated = false
          result.breeding = breeding
          result.error = breeding.errors.full_messages.to_sentence
        end
      end
      result
    end

    class Result
      attr_accessor :updated, :breeding, :error

      def initialize(breeding:, updated: false)
        @updated = updated
        @breeding = breeding
        @error = nil
      end

      def updated?
        @updated
      end
    end

    private

    def error(key)
      I18n.t("services.breedings.processor.#{key}")
    end
  end
end

