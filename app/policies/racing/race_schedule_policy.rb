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

    def post_parade?
      logged_in? && !record.past?
    end

    def claim?
      return false unless logged_in?
      false # TODO: replace with check for claims in this race

      # record.claiming_deadline >= Date.current
    end
  end
end

