module CurrentStable
  class BroodmarePolicy < ApplicationPolicy
    def breed?
      return false unless record.broodmare?
      return false if record.next_foal

      manager?
    end

    private

    def owner_not_leased?
      owner? && record.current_lease.blank?
    end

    def owner?
      record.owner == stable
    end

    def manager?
      record.manager == stable
    end
  end
end

