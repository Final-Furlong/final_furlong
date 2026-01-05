module Horses
  class WorkoutPolicy < ::ApplicationPolicy
    class Scope < ::ApplicationPolicy::Scope
      def resolve
        scope.all
      end
    end
  end
end

