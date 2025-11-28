module Racing
  class TrainingSchedulePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Racing::TrainingSchedule.where(stable: user.stable)
      end
    end

    def index?
      logged_in?
    end

    def new?
      return false unless user&.stable

      user.stable.reload.training_schedules.size < Config::Workouts.max_schedules_per_stable
    end

    def create?
      new?
    end

    def edit?
      owned_by_stable?
    end

    def destroy?
      owned_by_stable?
    end

    def view_horses?
      owned_by_stable?
    end

    private

    def owned_by_stable?
      record.stable == user&.stable
    end
  end
end

