module Horse
  class HighlightsController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.includes(race_series_wins: :series).find(params[:horse_id])
      authorize @horse, :view_highlights?, policy_class: Horses::HorsePolicy
    end
  end
end

