module CurrentStable
  class WorkoutPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(horse: Horses::Horse.managed_by(Current.stable))
      end
    end
  end
end

