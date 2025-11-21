module CurrentStable
  class SaleOffersController < AuthenticatedController
    def index
      query = policy_scope(Horses::SaleOffer, policy_scope_class: CurrentStable::SaleOfferPolicy::Scope).includes(:buyer, :owner, :horse)
      @pagy, @offers = pagy(:offset, query)
    end
  end
end

