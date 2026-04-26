module Horses
  class BreedingPolicy < ::ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.current_year
      end
    end

    def create?
      return false unless record.slot
      return false if record.slot.past?

      true
    end
  end
end

