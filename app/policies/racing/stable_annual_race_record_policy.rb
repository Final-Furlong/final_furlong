module Racing
  class StableAnnualRaceRecordPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(stable: Current.stable)
      end
    end
  end
end

