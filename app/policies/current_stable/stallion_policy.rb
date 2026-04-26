module CurrentStable
  class StallionPolicy < ApplicationPolicy
    def update_stud_options?
      return false unless record.stud?

      manager?
    end

    def manage_bookings?
      return false unless record.stud?

      manager?
    end

    def nominate?
      return false unless record.stud?

      owner_not_leased?
    end

    def view_nominations?
      record.stud_foals.born.exists?
    end

    private

    def owner_not_leased?
      owner? && record.current_lease.blank?
    end

    def owner?
      record.owner == user&.stable
    end

    def manager?
      record.manager == user&.stable
    end
  end
end

