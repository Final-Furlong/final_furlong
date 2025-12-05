module Horse
  class AuctionConsignmentsController < AuthenticatedController
    def new
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :consign_to_auction?, policy_class: CurrentStable::HorsePolicy

      @auctions = Auction.valid_for_horse(@horse)
    end

    def create
    end
  end
end

