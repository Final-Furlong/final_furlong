module CurrentStable
  class TrainingPolicy < ApplicationPolicy
    def index?
      stable.present?
    end
  end
end

