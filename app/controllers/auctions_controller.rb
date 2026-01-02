class AuctionsController < ApplicationController
  def index
    authorize Auction

    query = policy_scope(Auction.current.or(Auction.upcoming)).includes(:auctioneer).ransack(params[:q])
    query.sorts = "start_time asc, name asc" if query.sorts.blank?

    @pagy, @auctions = pagy(query.result)
  end

  def show
    @auction = Auction.find(params[:id])
    authorize @auction
  end

  def new
    @auction = Auction.new
    authorize @auction
  end

  def edit
    @auction = Auction.find(params[:id])
    authorize @auction
  end

  def create
    @auction = Auction.new
    authorize @auction

    result = Auctions::AuctionSaver.new.save_auction(auction_params:, auction: @auction)
    if result.created?
      flash[:success] = t(".success")
      redirect_to auctions_path(q: { upcoming: true })
    else
      @auction = result.auction
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("auction-form", partial: "auctions/form", locals: { auction: @auction, url: auctions_path })
        end
      end
    end
  end

  def update
    @auction = Auction.find(params[:id])
    authorize @auction

    result = Auctions::AuctionSaver.new.save_auction(auction_params:, auction: @auction)
    if result.created?
      flash[:success] = t(".success")
      redirect_to auctions_path(q: { upcoming: true })
    else
      @auction = result.auction
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("auction-form", partial: "auctions/form", locals: { auction: @auction, url: auction_path(@auction) })
        end
      end
    end
  end

  private

  def auction_params
    params.expect(auction: [:start_time, :duration_days, :hours_until_sold,
      :spending_cap_per_stable,
      :reserve_pricing_allowed, :racehorse_allowed_2yo,
      :racehorse_allowed_3yo, :racehorse_allowed_older,
      :stallion_allowed, :broodmare_allowed,
      :weanling_allowed, :yearling_allowed])
  end
end

