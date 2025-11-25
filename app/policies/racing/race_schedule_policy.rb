module Racing
  class RaceSchedulePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope
      end
    end

    def index?
      logged_in?
    end
  end
end

