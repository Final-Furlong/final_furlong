module CurrentStable
  class FutureRaceEntryPolicy < ApplicationPolicy
    def show?
      return false unless logged_in?
      return false if record.date < Date.current

      record.stable == stable
    end
  end
end

