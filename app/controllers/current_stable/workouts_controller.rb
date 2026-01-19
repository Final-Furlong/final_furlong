module CurrentStable
  class WorkoutsController < ApplicationController
    before_action :set_horse, except: :index

    def index
      query = policy_scope(Racing::Workout.all, policy_scope_class: CurrentStable::WorkoutPolicy::Scope)
      query = query.includes(:horse, :jockey, :racetrack, :comment).ransack(params[:q])
      query.sorts = "date desc" if query.sorts.blank?
      @pagy, @workouts = pagy(:offset, query.result)
    end

    def create
      workout = Racing::Workout.new(**workout_params.merge(horse:))
      if workout.valid?
        flash[:notice] = t(".success", horse: horse.name)
      else
        flash[:alert] = workout.errors.full_messages
      end
      redirect_to stable_training_schedules_path
    end

    private

    def set_horse
      @horse = Current.stable.horses.find(workout_params[:horse_id])
    end

    def workout_params
      params.expect(workout: [:horse_id, :activity1, :distance1, :activity2, :distance2, :activity3, :distance3])
    end
  end
end

