module CurrentStable
  class HorseShipmentPolicy < ApplicationPolicy
    def create?
      return false unless manager?
      return false unless shipping_allowed?
      if record.horse.racehorse?
        last_date = Shipping::RacehorseShipment.where(horse: record.horse).maximum(:arrival_date)
        return true unless last_date

        return last_date < Date.current
      elsif record.horse.broodmare?
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

