module CurrentStable
  class BroodmarePolicy < ApplicationPolicy
    def breed?
      # TODO: implement mare breeding
      false
    end

    private

    def owner_not_leased?
      owner? && record.current_lease.blank?
    end

    def owner?
      record.owner == user&.stable
    end
  end
end

