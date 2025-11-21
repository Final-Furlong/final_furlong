module CurrentStable
  class SaleOfferPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.sold_by(stable)
      end
    end

    def create?
      return false unless record.horse.owner == stable
      return false unless Horses::Status::SELLABLE_STATUSES.include?(record.horse.status)
      return false if record.horse.current_lease&.persisted?
      return false if record.horse.sale_offer.persisted?
      if record.horse.sales.count.positive?
        last_sale_date = record.horse.sales.maximum(:date)
        return true if last_sale_date < Date.current - Horses::SaleOffer::MINIMUM_WAIT_FROM_SALE

        if record.horse.racehorse?
          races_count = record.horse.race_result_finishes.joins(:race).merge(Racing::RaceResult.since_date(last_sale_date)).count
          races_count >= Horses::SaleOffer::MINIMUM_RACES
        elsif record.horse.stud?
          return false # TODO: hook up bookings check
        else
          return false
        end
      elsif record.horse.date_of_birth > Date.current - Horses::SaleOffer::MINIMUM_AGE
        return false
      end

      true
    end

    def accept?
      return false if owner?
      return false if record.blank?
      return false unless Date.current >= offer.offer_start_date
      return true if offer.buyer && offer.buyer == stable
      return false if offer.new_members_only && !stable.newbie?

      true
    end

    def destroy?
      return false if record.blank?
      return true if offer.owner == stable
      return true if offer.buyer == stable

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
      record.owner == stable
    end
  end
end

