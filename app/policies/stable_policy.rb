class StablePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:user).includes(:user).merge(User.active)
    end
  end

  def index?
    true
  end

  def edit?
    record.user == user || user&.admin?
  end
end
