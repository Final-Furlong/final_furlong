class NotificationPolicy < AuthenticatedPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.notifications
    end
  end

  def update?
    record.user == user
  end
end

