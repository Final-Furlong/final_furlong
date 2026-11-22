module Horses::Stud
  class FamousStudNominationPolicy < ::ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.current_year
      end
    end

    def create?
      logged_in?
    end
  end
end

