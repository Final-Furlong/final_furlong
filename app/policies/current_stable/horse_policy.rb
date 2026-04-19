module CurrentStable
  class HorsePolicy < ApplicationPolicy
    include Dry::Monads[:result]

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.managed_by(stable).alive
      end
    end

    def show?
      owner? || leaser?
    end

    def view_in_old_app?
      true
    end

    def geld?
      false # TODO: implement gelding
      # return false unless owner? || admin?
      # return false unless %w[colt stallion].include?(record.gender)

      # record.status != "stud"
    end

    def change_status?
      return false if record.current_lease
      return false unless Horses::Status::LIVING_STATUSES.include?(record.status)
      return false if Horses::Status::RETIRED_STATUSES.include?(record.status)

      owner? || admin?
    end

    def status_retired?
      Horses::Status::RETIREABLE_STATUSES.include?(record.status)
    end

    def status_broodmare?
      return false unless status_retired?
      return false unless record.female?
      return false if record.status == "broodmare"
      return true if record.historical_injuries.retireable.exists?
      return true if record.lifetime_race_record&.starts.to_i >= Config::Racing.min_races_to_retire

      false
    end

    def status_stud?
      return false unless status_retired?
      return false if record.status == "stud"
      return false if record.female?

      status_stud_result.success?
    end

    def status_stud_result
      return Failure(:not_old_enough) if record.age < Config::Breedings.min_age
      lrr = record.lifetime_race_record
      return Failure(:unraced) unless lrr

      return Failure(:not_enough_races) if lrr.starts.to_i < Config::Racing.min_races_to_retire
      return Failure(:not_enough_stakes_wins) if lrr.stakes_wins.to_i < Config::Racing.min_stud_stakes_wins
      stakes_places = lrr.stakes_seconds.to_i + lrr.stakes_thirds
      stakes_places += (lrr.stakes_wins - Config::Racing.min_stud_stakes_wins)
      return Failure(:not_enough_stakes_places) if stakes_places < Config::Racing.min_stud_stakes_places

      grade_1_wins = record.race_result_finishes.by_finish(1).joins(:race).merge(Racing::RaceResult.by_grade("Grade 1")).count
      return Failure(:not_enough_grade_1_wins) if grade_1_wins < Config::Racing.min_stud_grade_1_stakes_wins
      grade_1_places = record.race_result_finishes.by_max_finish(3).joins(:race).merge(Racing::RaceResult.by_grade("Grade 1")).count
      return Failure(:not_enough_grade_1_places) if grade_1_places < Config::Racing.min_stud_grade_1_stakes_places

      Success()
    end

    # when "racehorse"
    # ["stud"]

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

    def view_injuries?
      true
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

