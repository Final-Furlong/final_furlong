module Horses
  class BreedingPolicy < ::ApplicationPolicy
    include Dry::Monads[:result]

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.current_year
      end
    end

    def create?
      process_breeding_result.success?
    end

    def request_booking?
      request_booking_result.success?
    end

    def request_booking_result
      return Failure(:mare_not_old_enough) if record.mare.age < Config::Breedings.min_age
      return Failure(:stud_not_old_enough) if record.stud.age < Config::Breedings.min_age
      return Failure(:date_in_past) if record.slot&.past?
      stud_options = record.stud.stud_options
      return Failure(:approval_required) if stud_options.approval_required? && !record.approved?
      return Failure(:bookings_full) if stud_options.total_booked_count >= Config::Breedings.max_mares_per_year
      unless record.mare.manager == record.stud.manager
        return Failure(:cannot_afford_fee) if record.mare.manager.available_balance < stud_options.stud_fee
        return Failure(:outside_mare_limit_met) if stud_options.outside_mares_count >= stud_options.outside_mares_allowed
        bookings = record.stud.breedings.current_year.where.not(id: record.id).taken.where(stable: record.mare.manager).count
        return Failure(:outside_mare_limit_met_current_stable) if stud_options.outside_mares_per_stable.positive? && bookings >= stud_options.outside_mares_per_stable
      end

      Success()
    end

    def process_breeding_result
      return Failure(:mare_not_old_enough) if record.mare.age < Config::Breedings.min_age
      return Failure(:stud_not_old_enough) if record.stud.age < Config::Breedings.min_age
      return Failure(:slot_missing) unless record.slot
      return Failure(:date_in_past) if record.slot.past?
      stud_options = record.stud.stud_options
      return Failure(:approval_required) if stud_options.approval_required? && !record.approved?
      return Failure(:bookings_full) if record.stud.breedings.current_year.bred.count >= Config::Breedings.max_mares_per_year
      unless record.mare.manager == record.stud.manager
        return Failure(:cannot_afford_fee) if record.mare.manager.available_balance < stud_options.stud_fee
      end

      Success()
    end
  end
end

