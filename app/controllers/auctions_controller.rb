class AuctionsController < AuthenticatedController
  before_action :set_auction, except: %i[index new create]
  before_action :new_auction, only: %i[new create]
  before_action :authorize_auction, except: :index

  attr_accessor :auctions, :auction

  helper_method :auctions, :auction

  def index # rubocop:disable Metrics/AbcSize
    authorize Auction

    @query = authorized_scope(Auction.all).includes(:owner).ransack(params[:q])
    query.sorts = "name asc" if query.sorts.blank?

    @auctions = query.result.page(params[:page])
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
    if @auction.update(auction_params)
      @auction.reload
      respond_to do |format|
        format.html { redirect_to auctions_path, notice: t(".success", title: @auction.title) }
        format.turbo_stream { flash.now[:success] = t(".success", title: @auction.title) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def authorize_auction
    authorize @auction
  end

  def new_auction
    @auction = current_stable.auctions.build
  end

  def set_auction
    @auction = Auction.find(params[:id])
  end

  def auction_params
    params.require(:auction).permit(:name, :date_of_birth)
  end
end

