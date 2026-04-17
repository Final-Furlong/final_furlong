module CurrentStable
  class CurrentEntriesController < AuthenticatedController
    def index
      @query = policy_scope(Racing::RaceEntry, policy_scope_class: CurrentStable::RaceEntryPolicy::Scope)
      if params[:date]
        @date = Date.parse(params[:date]) if params[:date]
        @query = @query.where(race: { date: @date })
      end
      @query = @query.includes(race: { track_surface: :racetrack }, horse: :lifetime_race_record)
      @query = @query.order(race: { date: :asc, number: :asc }, horse: { name: :asc })

      @pagy, @results = pagy(:offset, @query)
    end
  end
end

