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

    def post_parade
      query = policy_scope(Racing::RaceSchedule).includes(entries: [:jockey, horse: [:owner, :leaser, :lifetime_race_record, sire: :lifetime_race_record, dam: :lifetime_race_record]], track_surface: :racetrack)
      @date = params[:date].presence || Racing::RaceSchedule.future.minimum(:date)
      query = query.where(date: @date)
      query = query.order(number: :asc)

      @races = query.to_a
      raise ActiveRecord::RecordNotFound if @races.empty?

      authorize @races.first, :post_parade?
    end
  end
end

