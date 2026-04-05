module CurrentStable
  class RaceResultHorsePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.by_stable(Current.stable)
      end
    end

    def index?
      logged_in?
    end

    def show?
      return false if record.race.date > Date.current

      logged_in?
    end
  end
end

