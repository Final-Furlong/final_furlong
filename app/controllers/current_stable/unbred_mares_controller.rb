module CurrentStable
  class UnbredMaresController < AuthenticatedController
    def index
      @query = policy_scope(Horses::Horse.broodmare.alive.where.missing(:next_foal), policy_scope_class: CurrentStable::HorsePolicy::Scope)
      @query = @query.order(name: :asc)

      @pagy, @mares = pagy(:countless, @query)
    end
  end
end

