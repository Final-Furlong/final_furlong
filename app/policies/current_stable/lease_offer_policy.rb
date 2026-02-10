module CurrentStable
  class LeaseOfferPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.with_owner(stable)
      end
    end

    def create_lease_offer?
      return false unless owner?
      return false unless Horses::Status::LEASEABLE_STATUSES.include?(record.status)
      return false if record.current_lease
      return false if record.lease_offer
      unless record.racehorse?
        return false unless Game::BreedingSeason.pre_breeding_season_date?(Date.current, Config::Leases.max_offer_period)
        return false if record.broodmare? && record.foals.unborn.exists?

        return true
      end

      true
    end

    def accept?
      return false if owner?
      return false if record.blank?
      return false unless Date.current >= offer.offer_start_date
      return true if offer.leaser && offer.leaser == stable
      return false if offer.new_members_only && !stable.newbie?

      true
    end

    def destroy?
      return false if record.blank?
      return true if offer.owner == stable
      return true if offer.leaser == stable

      false
    end

    def cancel?
      return false unless destroy?

      owner?
    end

    def reject?
      return false unless destroy?

      !owner?
    end

    private

    def owner_not_leased?
      owner? && record.current_lease.blank?
    end

    def offer
      record
    end

    def owner?
      record.owner == user&.stable
    end
  end
end

