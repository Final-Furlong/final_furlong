module Horse
  class RacesController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.includes(:annual_race_records, :lifetime_race_record).find(params[:id])
      authorize horse, :show?

      @dashboard = Dashboard::Horse::Racing.new(horse:, year: params[:year])
    end
  end
end

