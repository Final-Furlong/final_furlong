module Racing
  class TrainingScheduleHorsePolicy < ApplicationPolicy
    def index?
      deny!(:not_owner) unless record.stable == user&.stable

      allow!
    end

    def create?
      deny!(:not_owner) unless record.horse.owner == user&.stable
      deny!(:already_exists) if TrainingScheduleHorse.exists?(training_schedule: record.training_schedule, horse: record.horse)

      allow!
    end
  end
end

