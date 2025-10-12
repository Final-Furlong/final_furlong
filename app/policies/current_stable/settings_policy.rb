module CurrentStable
  class SettingsPolicy < ApplicationPolicy
    def new?
      user&.persisted?
    end
  end
end

