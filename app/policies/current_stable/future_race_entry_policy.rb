module CurrentStable
  class FutureRaceEntryPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(horse: Horses::Horse.racehorse.managed_by(stable))
      end
    end

    def show?
      return false unless logged_in?
      return false if record.date < Date.current

      record == stable
    end

    def future_races?
      return false unless logged_in?
      return false unless record == stable

      Racing::FutureRaceEntry.where(stable:).future.exists?
    end
  end
end

