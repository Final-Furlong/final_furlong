class NotificationPolicy < AuthenticatedPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user ? user.notifications : scope.none
    end
  end

  def update?
    record.user == user
  end
end

