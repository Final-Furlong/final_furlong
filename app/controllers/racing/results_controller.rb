module Racing
  class ResultsController < AuthenticatedController
    def index
      query = policy_scope(Racing::RaceResult).includes(track_surface: :racetrack)
      date = params[:date].presence || Racing::RaceResult.maximum(:date)
      query = query.where(date:)
      query = query.order(number: :asc) # TODO: replace with user-picked field(s)

      @races = query.to_a
    end

    def show
      @race = policy_scope(Racing::RaceResult.where(date: params[:date],
        number: params[:number])).first
      authorize @race
    end
  end
end

