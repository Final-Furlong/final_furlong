module CurrentStable
  class RaceEntryPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(stable:)
      end
    end

    def current_entries?
      Racing::RaceEntry.exists?(stable:)
    end
  end
end

