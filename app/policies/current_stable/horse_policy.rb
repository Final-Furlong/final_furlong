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

    def change_owner?
      false # TODO: implement owner change

      # admin?
    end

    def set_for_sale?
      # TODO: implement can be sold check
      false
    end

    def unset_for_sale?
      # TODO: migrate horse sale records
      false
    end

    def set_for_lease?
      # TODO: implement lease creation
      false
    end

    def cancel_lease_offer?
      # TODO: implement lease creation
      false
    end

    def terminate_lease?
      lease = record.current_lease
      return false if lease.blank?
      return false unless lease.leaser == stable || admin? || owner?
      unless lease.active?
        @error_message_key = :lease_not_active
        return false
      end

      termination = lease.termination_request
      return true unless termination

      if termination.owner_accepted_end && owner?
        @error_message_key = :lease_already_terminated
        return false
      elsif termination.leaser_accepted_end
        @error_message_key = :lease_already_terminated
        return false
      end

      true
    end

    def consign_to_auction?
      # TODO: implement auction consignment
      false
    end

    def remove_from_auction?
      # TODO: implement auction removal
      false
    end

    def update_racing_options?
      # TODO: implement racing options
      false
    end

    def update_stud_options?
      # TODO: implement stud options
      false
    end

    def breed_mare?
      # TODO: implement mare breeding
      false
    end

    def manage_bookings?
      # TODO: implement stud booking
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

    def nominate_racehorse?
      # TODO: migrate racehorse noms + implement them
      false
    end

    def nominate_stud?
      # TODO: migrate stallion noms + implement them
      false
    end

    def nominate_weanling?
      # TODO: migrate BC noms + implement them
      false
    end

    def enter_race?
      # TODO: migrate race entries + implement them
      false
    end

    def scratch_race?
      # TODO: migrate race entries + implement scratching
      false
    end

    def run_workout?
      # TODO: finish training schedules + workouts
      false
    end

    def run_jump_trial?
      # TODO: migrate jump trials + implement them
      false
    end

    def board_horse?
      # TODO: implment boarding
      false
    end

    def stop_boarding?
      # TODO: implment boarding
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

