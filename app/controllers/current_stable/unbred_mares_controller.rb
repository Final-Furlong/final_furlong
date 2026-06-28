module CurrentStable
  class UnbredMaresController < AuthenticatedController
    def index
      @query = policy_scope(Horses::Horse::Broodmare.alive.active.where.missing(:next_foal), policy_scope_class: CurrentStable::HorsePolicy::Scope)
      @query = @query.order(name: :asc)

      @mares = @query.to_a
    end
  end
end

