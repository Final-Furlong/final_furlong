class AuctionsController < ApplicationController
  def index
    authorize Auction

    query = policy_scope(Auction).includes(:auctioneer).ransack(params[:q])
    query.sorts = "name asc" if query.sorts.blank?

    @pagy, @auctions = pagy(query.result)
  end

  def show
    @auction = Auction.find(params[:id])
    authorize @auction
  end

  def edit
  end

  def update
  end
end

