module Horse
  class StatsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_stats?, policy_class: CurrentStable::HorsePolicy
    end
  end
end

