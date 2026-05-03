module CurrentStable
  class AuctionsController < AuthenticatedController
    def index
      query = policy_scope(Auctions::Bid).ransack(params[:q])
      auctions = Auction.joins(:bids).where(bids: query.result).distinct
      query.sorts = Config::Auctions.default_sort if query.sorts.blank?
      pagy, bids = pagy(:offset, query.result)

      @dashboard = Dashboard::Stable::Auction.new(query:, auctions:, bids:, pagy:, query_result: query.result)
    end

    def show
      @auction = Auction.find(params[:id])
      authorize @auction
    end
  end
end

