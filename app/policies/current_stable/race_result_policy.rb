module CurrentStable
  class RaceResultPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.joins(:horses).merge(Racing::RaceResultHorse.by_stable(Current.stable))
      end
    end

    def index?
      logged_in?
    end

    def race_results?
      index?
    end

    def recent_race_results?
      index?
    end

    def show?
      return false if record.date > Date.current

      logged_in?
    end
  end
end

