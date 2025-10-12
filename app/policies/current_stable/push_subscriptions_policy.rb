module CurrentStable
  class PushSubscriptionsPolicy < ApplicationPolicy
    def create?
      user.active?
    end

    def change?
      create?
    end
  end
end

