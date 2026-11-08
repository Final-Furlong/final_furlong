class CurrentStable::BreedersSeriesQualifiedController < AuthenticatedController
  def index
    @query = policy_scope(Horses::Horse::Racehorse.breeders_series_qualified_enterable, policy_scope_class: CurrentStable::HorsePolicy::Scope)
    @query = @query.includes(:racehorse_metadata, :manager)
    @query = @query.ransack(params[:q])
    @query.sorts = ["name asc"] if @query.sorts.blank?

    @count = @query.result.count
    @pagy, @results = pagy(:countless, @query.result)
  end
end

