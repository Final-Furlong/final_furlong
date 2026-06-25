module Horse
  class EntriesController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.includes(:manager, :race_metadata, :race_qualification, :race_options, latest_race_result_finish: { race: { track_surface: :racetrack } }).find(params[:id])
      authorize @horse, :enter_race?, policy_class: CurrentStable::RacehorsePolicy

      @current_entries = @horse.race_entries.includes(:race).order(date: :asc)
      @scheduled_entries = @horse.future_race_entries.includes(race: :track_surface).order(date: :asc)
    end
  end
end

