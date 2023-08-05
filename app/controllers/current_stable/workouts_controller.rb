module CurrentStable
  class WorkoutsController < ApplicationController
    before_action :set_horse

    # @route POST /stable/workouts (stable_workouts)
    def create
      workout = Racing::Workout.new(**workout_params.merge(horse: horse))
      if workout.valid?
        flash[:notice] = t(".success", horse: horse.name)
      else
        flash[:alert] = workout.errors.full_messages
      end
      redirect_to stable_training_schedules_path
    end

    private

    def set_horse
      @horse = current_stable.horses.find(workout_params[:horse_id])
    end

    def workout_params
      params.require(:workout).permit(:horse_id, :activity1, :distance1, :activity2, :distance2, :activity3, :distance3)
    end
  end
end

