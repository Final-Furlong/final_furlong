class AuthenticatedPolicy < ApplicationPolicy
  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user

    super
  end

  class Scope < ApplicationPolicy::Scope
    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, "must be logged in" unless user

      super
    end
  end
end

