module Horses
  class SaleOffersController < AuthenticatedController
    def index
      query = policy_scope(Horses::SaleOffer.includes(:buyer, horse: [:owner]))
      @pagy, @sale_offers = pagy(:offset, query)
    end
  end
end

