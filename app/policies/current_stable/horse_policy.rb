module CurrentStable
  class HorsePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Horses::HorsesQuery.new.owned_by(user.stable).living
      end
    end

    def show?
      owner?
    end

    def rename?
      false # TODO: implement renaming
      # return false unless owner? || admin?
      # return true if record.weanling?
      # return true if record.yearling?

      # record.created? && record.race_records.empty?
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

    def view_sales?
      # TODO: migrate sales
      false
    end

    def view_highlights?
      # TODO: migrate highlights
      false
    end

    def view_shipping?
      # TODO: migrate shipping
      false
    end

    def nominate_weanling?
      # TODO: migrate BC noms + implement them
      false
    end

    private

    def owner_not_leased?
      owner? && record.current_lease.blank?
    end

    def owner?
      record.owner == user&.stable
    end
  end
end

