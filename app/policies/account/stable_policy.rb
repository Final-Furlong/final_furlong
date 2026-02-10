module Account
  class StablePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.joins(:user).merge(Account::User.active).not_color_war
      end
    end

    def index?
      true
    end

    def edit?
      record.user == user
    end

    def update?
      edit?
    end

    def show?
      true
    end

    def impersonate?
      admin? && record.user != user
    end
  end
end

