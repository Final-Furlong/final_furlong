module CurrentStable
  class FutureEntriesController < AuthenticatedController
    def show
      @query = policy_scope(Racing::FutureRaceEntry.where(stable: Current.stable)).includes(:race)
      @date = Date.parse(params[:date])
      @query = @query.includes(:race, :horse).where(race: { date: @date }).order(entry_status: :asc, race: { number: :asc }, horse: { name: :asc })
      authorize @query.first, policy_class: CurrentStable::FutureRaceEntryPolicy

      @results = @query.to_a
    end
  end
end

