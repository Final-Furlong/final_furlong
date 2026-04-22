module Racing
  class TracksController < AuthenticatedController
    def index
      @racetracks = policy_scope(Racing::Racetrack.all).order(name: :asc)
      @next_race_dates = Racing::RaceSchedule.future.order(date: :asc).select(:date).distinct.limit(2)
    end
  end
end

