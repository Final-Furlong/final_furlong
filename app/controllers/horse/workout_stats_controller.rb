module Horse
  class WorkoutStatsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_workout_stats?, policy_class: CurrentStable::RacehorsePolicy
    end
  end
end

