module Racing
  class RaceEntryPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope
      end
    end

    def index?
      logged_in?
    end

    def show?
      return false if record.date >= Date.current

      logged_in?
    end

    def new?
      return false if record.date < Date.current
      return false if Date.current > record.race.entry_deadline

      logged_in?
    end
  end
end

