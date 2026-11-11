class CurrentStable::BreedersSeriesQualifiedController < AuthenticatedController
  def index
    @query = if !Racing::RaceSchedule.breeders_series.current_year.exists?
      policy_scope(Horses::Horse::Racehorse.none, policy_scope_class: CurrentStable::HorsePolicy::Scope)
    else
      policy_scope(Horses::Horse::Racehorse.breeders_series_qualified_enterable, policy_scope_class: CurrentStable::HorsePolicy::Scope)
    end
    @query = @query.includes(:racehorse_metadata, :manager)
    @query = @query.ransack(params[:q])
    @query.sorts = ["name asc"] if @query.sorts.blank?

    @count = @query.result.count
    @pagy, @results = pagy(:countless, @query.result)
  end
end

