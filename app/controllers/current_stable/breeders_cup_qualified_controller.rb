class CurrentStable::BreedersCupQualifiedController < AuthenticatedController
  def index
    @query = policy_scope(Horses::Racehorse.breeders_cup_qualified, policy_scope_class: CurrentStable::HorsePolicy::Scope)
    @query = @query.ransack(params[:q])
    @query.sorts = ["name asc"] if @query.sorts.blank?

    @count = @query.result.count
    @pagy, @results = pagy(:countless, @query.result)
  end
end

