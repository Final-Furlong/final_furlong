module Account
  class SettingsPolicy < ApplicationPolicy
    def update?
      true
    end
  end
end

