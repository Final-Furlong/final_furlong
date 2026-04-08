module CurrentStable
  class RecentResultsController < AuthenticatedController
    def show
      @query = policy_scope(Racing::RaceResultHorse, policy_scope_class: CurrentStable::RaceResultHorsePolicy::Scope).includes(:race)
      @date = Date.parse(params[:date])
      @query = @query.where(race: { date: @date }).order(race: { number: :asc })
      authorize @query.first.race

      @results = @query.to_a
    end
  end
end

