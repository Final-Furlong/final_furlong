module CurrentStable
  class SaleOffersController < AuthenticatedController
    def index
      query = policy_scope(Horses::SaleOffer).includes(:buyer, :owner, :horse)
      @pagy, @offers = pagy(:offset, query)
    end
  end
end

