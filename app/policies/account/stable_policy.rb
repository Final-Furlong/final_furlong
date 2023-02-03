module Account
  class StablePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        Account::StablesRepository.new(scope:).active
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
      user&.admin && record.user != user
    end
  end
end

