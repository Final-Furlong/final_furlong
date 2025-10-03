module Racing
  class TrainingSchedulePolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Racing::TrainingSchedule.where(stable: user.stable)
      end
    end

    def new?
      return false unless user&.stable

      user.stable.reload.training_schedules.size < Racing::TrainingSchedule::MAX_SCHEDULES_PER_STABLE
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

