module CurrentStable
  class TrainingSummaryPolicy < ApplicationPolicy
    def show?
      Horses::Horse::Racehorse.managed_by(stable).exists?
    end
  end
end

