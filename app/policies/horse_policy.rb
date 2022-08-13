class HorsePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.born
    end
  end
end

