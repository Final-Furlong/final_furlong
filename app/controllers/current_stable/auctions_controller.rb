module CurrentStable
  class AuctionsController < AuthenticatedController
    def index
      query = policy_scope(Auctions::Bid).ransack(params[:q])
      query.sorts = Config::Auctions.default_sort if query.sorts.blank?
      pagy, bids = pagy(:offset, query.result)

      @dashboard = Dashboard::Stable::Auction.new(query:, bids:, pagy:, query_result: query.result)
    end

    def show
      @auction = Auction.find(params[:id])
      authorize @auction
    end
  end
end

