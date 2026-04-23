module CurrentStable
  class JumpTrialsController < ApplicationController
    before_action :set_horse, except: :index

    def index
      query = policy_scope(Workouts::JumpTrial.all, policy_scope_class: CurrentStable::WorkoutPolicy::Scope)
      query = query.includes(:horse, :jockey, :racetrack, :comment).ransack(params[:q])
      query.sorts = "date desc" if query.sorts.blank?
      @pagy, @trials = pagy(:offset, query.result)
    end
  end
end

