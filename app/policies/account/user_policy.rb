module Account
  class UserPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.active
      end
    end

    def create?
      user&.admin?
    end

    def impersonate?
      user&.admin? && user != record
    end

    def permitted_attributes
      %i[name email]
    end

    def permitted_attributes_for_create
      %i[username name email password password_confirmation stable_name]
    end
  end
end

