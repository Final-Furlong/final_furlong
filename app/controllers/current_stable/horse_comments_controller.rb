module CurrentStable
  class HorseCommentsController < AuthenticatedController
    def index
      @query = policy_scope(Horses::Horse.where.associated(:comments), policy_scope_class: CurrentStable::HorsePolicy::Scope)
      @query = @query.includes(:comments).ransack(params[:q])
      @query.sorts = "name asc" if @query.sorts.blank?
      @count = @query.result.count
      @pagy, @horses = pagy(:countless, @query.result)
    end
  end
end

