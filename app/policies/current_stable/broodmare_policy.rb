module CurrentStable
  class BroodmarePolicy < ApplicationPolicy
    def breed?
      return false unless record.broodmare?
      return false unless record.age >= Config::Breedings.min_age
      return false if Horses::Breeding.in_foal.exists?(mare: record)

      manager?
    end

    def create_booking?
      return false unless record.broodmare?
      return false unless record.age >= Config::Breedings.min_age

      !Horses::Breeding.bred.current_year.exists?(mare: record)
    end

    private

    def owner_not_leased?
      owner? && record.current_lease.blank?
    end

    def owner?
      record.owner_id == stable&.id
    end

    def manager?
      record.manager_id == stable&.id
    end
  end
end

