module Racing
  class RaceResultPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope
      end
    end

    def index?
      logged_in?
    end

    def show?
      return false if record.date > Date.current

      logged_in?
    end
  end
end

