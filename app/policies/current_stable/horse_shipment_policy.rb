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
      return false unless record.horse.racehorse? || record.horse.broodmare?
      return false if record.horse.shipments.future.present?
      if record.horse.racehorse?
        return false if record.horse.race_entries.present?
        return false if record.horse.current_boarding.present?
        last_date = Horses::Racehorse::Shipment.where(horse: record.horse).maximum(:arrival_date)
        return true unless last_date

        return last_date < Date.current
      elsif record.horse.broodmare?
        last_date = Horses::Broodmare::Shipment.where(horse: record.horse).maximum(:arrival_date)
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
      return false unless record.horse.active?

      record.horse.racehorse? || record.horse.broodmare?
    end

    def leaser?
      return false if record.current_lease.blank?

      record.current_lease.leaser_id == stable&.id
    end

    def owner?
      record.horse.owner_id == stable&.id
    end

    def manager?
      record.horse.manager_id == stable&.id
    end
  end
end

