module Racing
  class RacesController < AuthenticatedController
    def index
      query = policy_scope(Racing::RaceSchedule).includes(track_surface: :racetrack)
      date = params[:date].presence || Racing::RaceSchedule.future.minimum(:date)
      query = query.where(date:)
      query = query.order(number: :asc) # TODO: replace with user-picked field(s)

      @races = query.to_a
    end

    def show
    end
  end
end

