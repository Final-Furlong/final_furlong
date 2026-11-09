class CurrentStable::BreedersCupQualifiedController < AuthenticatedController
  def index
    @query = if Racing::BreedersCupPotentialEntry.exists? && Racing::RaceSchedule.breeders_cup.current_year.exists?
      policy_scope(Horses::Horse::Racehorse.breeders_cup_qualified_enterable, policy_scope_class: CurrentStable::HorsePolicy::Scope)
    else
      policy_scope(Horses::Horse::Racehorse.breeders_cup_qualified, policy_scope_class: CurrentStable::HorsePolicy::Scope)
    end
    @query = @query.ransack(params[:q])
    @query.sorts = ["name asc"] if @query.sorts.blank?

    @count = @query.result.count
    @pagy, @results = pagy(:countless, @query.result)
  end
end

