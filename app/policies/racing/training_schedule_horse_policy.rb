module Racing
  class TrainingScheduleHorsePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        refined_scope = scope.managed_by(stable)
        if (energy = game_settings[:minimum_energy])
          refined_scope = refined_scope.joins(:race_metadata).merge(Racing::RacehorseMetadata.min_energy(energy))
        end
        refined_scope
      end

      def game_settings
        return {} unless user.setting.racing
        {
          minimum_energy: user.setting.racing.min_energy_for_workout
        }
      end
    end

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

