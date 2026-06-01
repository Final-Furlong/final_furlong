module Racing
  class SeriesWinnersController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: %i[index show]

    def index
      @series = Racing::RaceSeries.all
    end

    def show
      @series = Racing::RaceSeries.find(params[:id])
      @winners = @series.winners.includes(:horse)
    end
  end
end

