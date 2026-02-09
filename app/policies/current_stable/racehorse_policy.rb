module CurrentStable
  class RacehorsePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        refined_scope = scope.managed_by(stable)
        if (energy = game_settings[:minimum_energy])
          refined_scope = refined_scope.where(race_metadata: {
            energy_grade: energy
          })
        end
        if (min_days = game_settings[:minimum_days_since_last_race])
          refined_scope = refined_scope.where(race_metadata: {
            last_raced_at:
              ..(Date.current - min_days.days)
          })
        end
        refined_scope
      end

      def game_settings
        return {} unless user.setting.racing
        {

          minimum_energy: user.setting.racing.min_energy_for_race_entry,
          minimum_days_since_last_race: user.setting.racing.min_days_delay_from_last_race,
          minimum_days_since_last_injury: user.setting.racing.min_days_delay_from_last_injury,
          minimum_rest_days_since_last_race: user.setting.racing.min_days_rest_between_races,
          minimum_workouts_since_last_race: user.setting.racing.min_workouts_between_races
        }
      end
    end

    def update_race_options?
      return false unless record.racehorse?
      return false if record.race_options.blank?

      manager?
    end

    def nominate?
      # TODO: migrate racehorse noms + implement them
      false
    end

    def enter_race?
      # TODO: migrate race entries + implement them
      false
    end

    def scratch_race?
      # TODO: migrate race entries + implement scratching
      false
    end

    def board?
      # TODO: migrate boarding
      false
    end

    def stop_boarding?
      Horses::Boarding.current.exists?(horse: record)
    end

    def run_workout?
      # TODO: finish training schedules + workouts
      false
    end

    def run_jump_trial?
      # TODO: migrate jump trials + implement them
      false
    end

    private

    def owner_not_leased?
      owner? && record.current_lease.blank?
    end

    def owner?
      record.owner == user&.stable
    end

    def manager?
      record.manager == user&.stable
    end
  end
end

