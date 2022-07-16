class StablePolicy < ApplicationPolicy
  def show?
    record.user == user
  end
end
