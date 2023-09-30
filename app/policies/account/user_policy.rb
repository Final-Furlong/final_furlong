module Account
  class UserPolicy < ApplicationPolicy
    scope_for :relation do |relation|
      Account::UsersQuery.new.active.ordered
    end

    def index?
      user&.admin?
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

