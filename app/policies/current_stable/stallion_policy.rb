module CurrentStable
  class StallionPolicy < ApplicationPolicy
    def update_stud_options?
      # TODO: implement stud options
      false
    end

    def manage_bookings?
      # TODO: implement stud booking
      false
    end

    def nominate?
      # TODO: migrate stallion noms + implement them
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

