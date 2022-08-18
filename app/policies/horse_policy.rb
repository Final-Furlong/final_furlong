class HorsePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.born
    end
  end

  def index?
    true
  end

  def show?
    !record.unborn?
  end
end

