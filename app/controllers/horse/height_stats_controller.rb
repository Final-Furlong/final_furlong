module Horse
  class HeightStatsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.includes(:appearance, :racing_stats).find(params[:id])
      authorize @horse, :view_height_stats?, policy_class: CurrentStable::HorsePolicy
    end
  end
end

