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

    def set_for_sale?
      # TODO: implement can be sold check
      false
    end

    def unset_for_sale?
      # TODO: migrate horse sale records
      false
    end

    def consign_to_auction?
      # TODO: implement auction consignment
      false
    end

    def remove_from_auction?
      # TODO: implement auction removal
      false
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
      return false unless record.manager == stable

      record.racehorse?
    end

    def view_workouts?
      return false unless record.manager == stable

      record.racehorse?
    end

    def view_boarding?
      return false unless record.manager == stable

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
  end
end

