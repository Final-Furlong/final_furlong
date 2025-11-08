module Account
  class BudgetPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Account::Budget.where(stable: user.stable)
      end
    end

    def index?
      Current.user.active?
    end
  end
end

