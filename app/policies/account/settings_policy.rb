module Account
  class SettingsPolicy < ApplicationPolicy
    def create?
      true
    end
  end
end

