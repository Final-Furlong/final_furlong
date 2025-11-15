module Horses
  class LeasePolicy < ::AuthenticatedPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.valid_for_stable(stable)
      end
    end
  end
end

