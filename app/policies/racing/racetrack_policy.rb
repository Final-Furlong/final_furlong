module Racing
  class RacetrackPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where.not(name: Config::Game.stable)
      end
    end
  end
end

