module Auctions
  class BidsController < AuthenticatedController
    def new
    end

    def create
      auction = Auction.find(params[:auction_id])
      auction_horse = auction.horses.find(params[:horse_id])
      authorize auction_horse, :bid?

      new_bid_params = bid_params.merge(
        auction_id: auction.id, horse_id: auction_horse.horse.id,
        bidder_id: Current.stable.id
      )
      result = Auctions::BidCreator.new.create_bid(new_bid_params)
      if result.created?
        flash[:success] = t(".success")
        redirect_to auction_horse_path(auction, auction_horse, tab: :bidding)
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.turbo_stream { render :new, status: :unprocessable_entity, locals: { auction_horse:, auction:, new_bid: result.bid } }
        end
      end
    end

    private

    def bid_params
      params.expect(bid: [:current_bid, :maximum_bid, :notify_if_outbid])
    end
  end
end

