module CurrentStable
  class TrainingSummaryPolicy < ApplicationPolicy
    def show?
      Horses::Horse.racehorse.managed_by(stable).exists?
    end
  end
end

