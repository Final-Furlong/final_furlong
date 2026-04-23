module Workouts
  class JumpTrialPolicy < ApplicationPolicy
    def index?
      stable.horses.racehorse.exists?
    end
  end
end

