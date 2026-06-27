module Racing
  class HorseJockeyRelationshipPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.joins(:horse).merge(Horses::Horse::Racehorse.managed_by(stable))
      end
    end
  end
end

