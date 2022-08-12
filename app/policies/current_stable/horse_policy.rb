module CurrentStable
  class HorsePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.owned_by(user.stable).living
      end
    end
  end
end

