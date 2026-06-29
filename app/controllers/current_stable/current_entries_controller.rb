module CurrentStable
  class CurrentEntriesController < AuthenticatedController
    def index
      @query = policy_scope(Racing::RaceEntry, policy_scope_class: CurrentStable::RaceEntryPolicy::Scope)
      # if params[:date]
      # @date = Date.parse(params[:date]) if params[:date]
      # @query = @query.where(race: { date: @date })
      # end
      @query = @query.includes(horse: [:racehorse_metadata, :manager], race: { track_surface: :racetrack })
      @query = @query.ransack(params[:q])
      @query.sorts = ["race_date asc", "race_number asc", "name asc"] if @query.sorts.blank?
      # @query = @query.order(race: { date: :asc, number: :asc }, horse: { name: :asc })

      @count = @query.result.count
      @pagy, @results = pagy(:countless, @query.result)
    end
  end
end

