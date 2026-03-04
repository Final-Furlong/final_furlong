module Workouts
  class WorkoutPolicy < ApplicationPolicy
    def index?
      stable.horses.racehorse.exists?
    end
  end
end

