module CurrentStable
  class StallionPolicy < ApplicationPolicy
    def update_stud_options?
      return false unless record.stud?
      return false unless record.age >= Config::Breedings.min_age

      manager?
    end

    def manage_bookings?
      return false unless record.stud?
      return false unless record.age >= Config::Breedings.min_age

      manager?
    end

    def nominate?
      return false unless record.stud?
      return false unless record.age >= Config::Breedings.min_age
      return false if record.nominations.current_year.exists?
      raced_this_year = record.annual_race_records.by_year(Date.current.year).exists?
      return false if !raced_this_year && (Date.current.month > Config::Racing.breeders_cup_stud_nomination_deadline_month ||
        (Date.current.month == Config::Racing.breeders_cup_stud_nomination_deadline_month && Date.current.day > Config::Racing.breeders_cup_stud_nomination_deadline_day))

      owner_not_leased?
    end

    def view_nominations?
      record.nominations.exists? || record.breedings.not_denied.exists?
    end

    private

    def owner_not_leased?
      owner? && manager?
    end

    def owner?
      record.owner_id == user&.stable&.id
    end

    def manager?
      record.manager_id == user&.stable&.id
    end
  end
end

