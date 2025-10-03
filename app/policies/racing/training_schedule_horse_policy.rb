module Racing
  class TrainingScheduleHorsePolicy < ApplicationPolicy
    def index?
      record.stable == user&.stable
    end

    def create?
      return false unless record.horse.owner == user&.stable
      return false if TrainingScheduleHorse.exists?(training_schedule: record.training_schedule, horse: record.horse)

      true
    end
  end
end

