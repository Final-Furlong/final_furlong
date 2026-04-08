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
      race = Racing::RaceSchedule.find(params[:race_id])
      @entry = Racing::RaceEntry.new(date: race.date, race:)
      authorize @entry, :show?
    end

    def destroy
      race = Racing::RaceSchedule.find(params[:race_id])
      @entry = Racing::RaceEntry.find(params[:id])
      authorize @entry, :scratch?

      result = Racing::EntryScratcher.new.scratch_entry(entry: @entry, stable: Current.stable)
      if result.scratched?
        flash[:success] = result.message
      else
        flash[:error] = result.error
      end
      redirect_to new_racing_race_entry_path(race)
    end
  end
end

