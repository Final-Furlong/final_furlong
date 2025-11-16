module Horses
  class LeaseTerminator
    attr_reader :lease

    def call(current_lease:, stable:, params:)
      @lease = current_lease
      validation_context = (stable == lease.owner) ? :owner_update : :leaser_update

      result = Result.new(lease:)
      termination = lease.reload.termination_request || lease.build_termination_request
      termination.assign_attributes(params)
      ActiveRecord::Base.transaction do
        if termination.valid?(validation_context) && termination.save
          if termination.reload.both_sides_accept?
            process_refund if termination.both_sides_accept_refund?
            update_legacy_tables(lease.horse)
            lease.update(active: false, early_termination_date: Date.current)
            termination.destroy!
            result.terminated = true
          else
            result.created = true
          end
        else
          result.created = false
          result.error = termination.errors.full_messages.to_sentence
        end
        result.termination = termination
      rescue ActiveRecord::ActiveRecordError => e
        result.created = false
        result.terminated = false
        result.termination = termination
        result.error = e.message
      end
      result
    end

    class Result
      attr_accessor :error, :created, :termination, :terminated

      def initialize(lease:, created: false, error: nil, terminated: false)
        @created = created
        @lease = lease
        @error = nil
        @termination = nil
        @terminated = false
      end

      def created?
        @created
      end

      def terminated?
        @terminated
      end
    end

    private

    def update_legacy_tables(horse)
      legacy_horse = Legacy::Horse.find_by(ID: horse.legacy_id)
      legacy_horse&.update(Leased: 0, Leaser: 0)
      Legacy::ViewRacehorses.find_by(horse_id: horse.legacy_id)&.update(leased: 0, leaser: 0)
      Legacy::ViewTrainingSchedules.find_by(horse_id: horse.legacy_id)&.update(leased: 0, leaser: 0)
    end

    def process_refund
      time_left = (lease.end_date - Date.current).to_i
      percentage_left = time_left.fdiv(lease.total_days)
      refund_fee = (lease.fee * percentage_left).to_i

      description = "Lease Refund: #{lease.horse.name}"
      Accounts::BudgetTransactionCreator.new.create_transaction(stable: lease.leaser, description:, amount: refund_fee.abs)
      Accounts::BudgetTransactionCreator.new.create_transaction(stable: lease.owner, description:, amount: refund_fee.abs * -1)
    end
  end
end

