module Racing
  class DistanceRaceRecordPolicy < ApplicationPolicy
    def show?
      logged_in?
    end
  end
end

