class HorsePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.living
    end
  end
end

