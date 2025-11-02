module Api
  module V1
    class AuctionHorses < Grape::API
      include Api::V1::Defaults

      resource :auction_horses do
        desc "Consign a horse to an auction"
        params do
          requires :auction_id, type: Integer, desc: "Unique id for the Auction"
          requires :horse_id, type: Integer, desc: "Unique id for the Horses::Horse"
          requires :stable_id, type: Integer, desc: "Unique id for the Account::Stable"
          optional :reserve_price, type: Integer, desc: "Reserve price for the horse"
          optional :comment, type: String, desc: "Comment relating to the bid"
        end
        post "/" do
          result = Auctions::HorseCreator.new.create_horse(
            auction_id: params[:auction_id],
            horse_id: params[:horse_id],
            stable_id: params[:stable_id],
            reserve_price: params[:reserve_price],
            comment: params[:comment]
          )
          error!({ error: "invalid", detail: result.error }, 500) unless result.created?

          { auction_horse_id: result.horse&.id }
        end
      end
    end
  end
end

