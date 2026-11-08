module CurrentStable
  class CurrentEntriesController < AuthenticatedController
    def index
      @query = policy_scope(Racing::RaceEntry, policy_scope_class: CurrentStable::RaceEntryPolicy::Scope)
      @query = @query.includes(horse: [:racehorse_metadata, :manager], race: { track_surface: :racetrack })
      @query = @query.ransack(params[:q])
      @query.sorts = ["race_date asc", "race_number asc", "name asc"] if @query.sorts.blank?

      @count = @query.result.count
      @pagy, @results = pagy(:countless, @query.result)
    end
  end
end

