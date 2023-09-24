module Racing
  class TrainingSchedulePolicy < ApplicationPolicy
    scope_for :active_record_relation do |relation|
      Racing::TrainingScheduleQuery.with_stable(user.stable).ordered
    end

    def new?
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
      record.stable == user.stable
    end
  end
end

