module Auctions
  class HorsesController < AuthenticatedController
    def show
      @auction = Auction.find(params[:auction_id])
      @auction_horse = @auction.horses.find(params[:id])
      authorize @auction_horse
    end

    def new
    end

    def edit
    end

    def create
    end

    def update
    end

    def destroy
    end
  end
end

