module Horses
  class LeaseOffersController < AuthenticatedController
    def index
      query = policy_scope(Horses::LeaseOffer.includes(:leaser, horse: [:owner]))
      @pagy, @lease_offers = pagy(:countless, query)
    end
  end
end

