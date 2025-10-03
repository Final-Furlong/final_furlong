module Account
  class UserPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Account::UsersQuery.new.active.ordered
      end
    end

    def index?
      admin?
    end

    def create?
      admin?
    end

    def impersonate?
      admin? && user != record
    end

    def permitted_attributes
      %i[name email]
    end

    def permitted_attributes_for_create
      %i[username name email password password_confirmation stable_name]
    end
  end
end

