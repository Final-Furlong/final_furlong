module CurrentStable
  class HorsePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Horses::HorsesQuery.new.owned_by(user.stable).living
      end
    end

    def show?
      owner? || leaser?
    end

    def geld?
      false # TODO: implement gelding
      # return false unless owner? || admin?
      # return false unless %w[colt stallion].include?(record.gender)

      # record.status != "stud"
    end

    def change_status?
      false # TODO: implement status update
      # return true if admin?

      # owner_not_leased? || admin?
    end

    def ship?
      shipment = if record.racehorse?
        Shipping::RacehorseShipment.new(horse: record)
      elsif record.broodmare?
        Shipping::BroodmareShipment.new(horse: record)
      else
        return false
      end
      HorseShipmentPolicy.new(user, shipment).create?
    end

    def consign_to_auction?
      return false unless owner?
      return false unless Horses::Status::SELLABLE_STATUSES.include?(record.status)
      return false if record.current_lease&.persisted?
      return false if record.sale_offer&.persisted?
      return false if record.auction_horse&.persisted?
      return false if Auction.valid_for_horse(record).empty?
      if record.sales.count.positive?
        last_sale_date = record.sales.maximum(:date)
        return true if last_sale_date < Date.current - Config::Sales.minimum_wait_from_last_sale.days

        if record.racehorse?
          races_count = record.race_result_finishes.joins(:race).merge(Racing::RaceResult.since_date(last_sale_date)).count
          races_count >= Config::Sales.minimum_races
        elsif record.stud?
          return false # TODO: hook up bookings check
        else
          return false
        end
      elsif record.date_of_birth > Date.current - Config::Sales.minimum_age.days
        return false
      end

      true
    end

    def remove_from_auction?
      return false unless owner?
      auction_horse = record.auction_horse
      return false unless auction_horse
      return false unless auction_horse.persisted?
      auction = auction_horse.auction

      auction.future?
    end

    def view_comments?
      # TODO: migrate comments + implement editing them
      false
    end

    def view_events?
      return true if owner?

      view_sales?
    end

    def view_sales?
      logged_in?
    end

    def view_highlights?
      false
    end

    def view_shipping?
      return false unless manager?

      record.racehorse? || record.broodmare?
    end

    def view_workouts?
      return false unless manager?

      record.racehorse?
    end

    def create_workout?
      return false unless manager?
      return false unless record.racehorse?

      !record.workouts.exists?(date: Date.current)
    end

    def view_boarding?
      return false unless manager?

      record.racehorse?
    end

    def nominate_weanling?
      # TODO: migrate BC noms + implement them
      false
    end

    private

    def leaser?
      return false if record.current_lease.blank?

      record.current_lease.leaser == user&.stable
    end

    def owner?
      record.owner == user&.stable
    end

    def manager?
      record.manager == stable
    end
  end
end

