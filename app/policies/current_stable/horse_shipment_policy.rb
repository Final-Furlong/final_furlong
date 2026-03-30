module CurrentStable
  class HorseShipmentPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.managed_by(user.stable)
      end
    end

    def create?
      return false unless manager?
      return false unless shipping_allowed?
      if record.horse.racehorse?
        return false if record.horse.race_entries.present?
        return false if record.horse.current_boarding.present?
        return false if record.horse.racing_shipments.future.present?
        last_date = Shipping::RacehorseShipment.where(horse: record.horse).maximum(:arrival_date)
        return true unless last_date

        return last_date < Date.current
      elsif record.horse.broodmare?
        return false if record.horse.broodmare_shipments.future.present?
        last_date = Shipping::BroodmareShipment.where(horse: record.horse).maximum(:arrival_date)
        return true unless last_date

        return last_date < Date.current
      end

      false
    end

    def destroy?
      return false unless manager?
      return false unless shipping_allowed?
      return false if record.departure_date <= Date.current

      true
    end

    private

    def shipping_allowed?
      record.horse.racehorse? || record.horse.broodmare?
    end

    def leaser?
      return false if record.current_lease.blank?

      record.current_lease.leaser == user&.stable
    end

    def owner?
      record.horse.owner == user&.stable
    end

    def manager?
      record.horse.manager == stable
    end
  end
end

