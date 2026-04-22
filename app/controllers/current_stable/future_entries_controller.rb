module CurrentStable
  class FutureEntriesController < AuthenticatedController
    def show
      @query = policy_scope(Racing::FutureRaceEntry.current_or_future.where(stable: Current.stable)).includes(:race)
      @query = @query.includes(race: { track_surface: :racetrack }, horse: :lifetime_race_record)
      if params[:date]
        @date = Date.parse(params[:date]) if params[:date]
        @query = @query.where(race: { date: @date })
      end
      @query = @query.merge(Racing::FutureRaceEntry.ordered_by_status).order(race: { date: :asc, number: :asc }, horse: { name: :asc })
      authorize @query.first, policy_class: CurrentStable::FutureRaceEntryPolicy

      @pagy, @results = pagy(:offset, @query)
    end
  end
end
