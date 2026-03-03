module Horse
  class RaceStatsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:id])
      authorize horse, :view_race_stats?, policy_class: CurrentStable::RacehorsePolicy

      # @dashboard = Dashboard::Horse::Racing.new(horse:, year: params[:year])
    end
  end
end

