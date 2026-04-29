module CurrentStable
  class BroodmarePolicy < ApplicationPolicy
    def breed?
      return false unless record.broodmare?
      return false if Horses::Breeding.in_foal.exists?(mare: record)
      return false unless record.age >= Config::Breedings.min_age

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

