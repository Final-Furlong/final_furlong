module Racing
  class EntriesController < AuthenticatedController
    def index
      authorize Racing::RaceEntry, :index?

      query = policy_scope(Racing::RaceEntry)
      date = params[:date].presence || Racing::RaceSchedule.future.minimum(:date)
      query = query.where(date:)
      query = query.order(number: :asc) # TODO: replace with user-picked field(s)

      @races = query.to_a
    end

    def show
    end

    def new
      race = Racing::RaceSchedule.find_by!(date: params[:date], number: params[:number])
      @entry = Racing::RaceEntry.new(date: race.date, race:)
      authorize @entry
    end
  end
end

