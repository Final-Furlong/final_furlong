module Account
  class SettingsPolicy < ApplicationPolicy
    def create?
      true
    end

    def new?
      Current.user.present?
    end
  end
end

