module CurrentStable
  class LeasePolicy < ApplicationPolicy
    def terminate?
      return false if lease.blank?
      return false unless lease.leaser == stable || owner?
      unless lease.active?
        @error_message_key = :lease_not_active
        return false
      end

      termination = lease.termination_request
      return true unless termination

      if termination.owner_accepted_end && owner?
        @error_message_key = :lease_already_terminated
        return false
      elsif termination.leaser_accepted_end && lease.leaser == stable
        @error_message_key = :lease_already_terminated
        return false
      end

      true
    end

    private

    def lease
      record
    end

    def owner?
      record.owner == user&.stable
    end
  end
end

