module Horse
  class EntriesController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :enter_race?, policy_class: CurrentStable::RacehorsePolicy

      @current_entries = @horse.race_entries.order(date: :asc)
      @scheduled_entries = @horse.future_race_entries.includes(race: :track_surface).order(date: :asc)
    end
  end
end

