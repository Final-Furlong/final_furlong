module Account
  class StablePolicy < ApplicationPolicy
    scope_for :active_record_relation do |relation|
      Account::StablesQuery.new.active
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
      user&.admin && record.user != user
    end
  end
end

