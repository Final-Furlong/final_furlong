class FooStablePolicy < ApplicationPolicy
  def show?
    record.user == user
  end
end
