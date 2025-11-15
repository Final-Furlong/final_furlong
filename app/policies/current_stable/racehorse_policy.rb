module CurrentStable
  class RacehorsePolicy < ApplicationPolicy
    def update_racing_options?
      # TODO: implement racing options
      false
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

    def run_workout?
      # TODO: finish training schedules + workouts
      false
    end

    def run_jump_trial?
      # TODO: migrate jump trials + implement them
      false
    end

    def board?
      # TODO: implment boarding
      false
    end

    def stop_boarding?
      # TODO: implment boarding
      false
    end

    private

    def owner_not_leased?
      owner? && record.current_lease.blank?
    end

    def owner?
      record.owner == user&.stable
    end
  end
end

