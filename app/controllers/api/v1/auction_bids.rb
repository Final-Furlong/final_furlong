module Api
  module V1
    class AuctionBids < Grape::API
      include Api::V1::Defaults

      resource :auction_bids do
        desc "Create a bid on a horse"
        params do
          requires :auction_id, type: Integer, desc: "Unique id for the Auction"
          requires :horse_id, type: Integer, desc: "Unique id for the Auction::Horse"
          requires :bidder_id, type: Integer, desc: "Unique id for the Account::Stable"
          requires :current_bid, type: Integer, desc: "Current bid amount"
          requires :maximum_bid, type: Integer, desc: "Maximum bid amount"
          optional :comment, type: String, desc: "Comment relating to the bid"
        end
        post "/" do
          result = Auctions::BidCreator.new.create_bid(
            auction_id: params[:auction_id],
            horse_id: params[:horse_id],
            bidder_id: params[:bidder_id],
            current_bid: params[:current_bid],
            maximum_bid: params[:maximum_bid],
            comment: params[:comment]
          )
          error!({ error: "invalid", detail: result.error }, 500) unless result.created?

          { bid_id: result.bid&.id }
        end
      end
    end
  end
end

