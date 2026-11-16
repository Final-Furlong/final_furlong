module Racing
  class BreedersSeriesWinnersController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: %i[index show]

    def index
      @years = Racing::RaceResult.breeders_series.select("DISTINCT(DATE_PART('Year', date))").to_a.map(&:date_part)
    end

    def show
      @year = params[:id]
      @stables = Racing::BreedersSeriesStableStanding.where(year: @year).order(points: :desc, name: :asc)
    end
  end
end

