module Racing
  class TrainingScheduleRepository < ApplicationRepository
    def initialize(model: TrainingSchedule, scope: nil)
      @model = model
      super
    end

    def with_stable(stable)
      scope.where(stable: stable)
    end

    def ordered
      scope.order(name: :asc)
    end
  end
end

