class AuthenticatedPolicy < ApplicationPolicy
  pre_check :disallow_guests

  private

    def disallow_guests
      deny! unless user
    end
end

