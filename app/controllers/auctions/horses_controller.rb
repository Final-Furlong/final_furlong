module Auctions
  class HorsesController < AuthenticatedController
    def show
      @auction = Auction.find(params[:auction_id])
      @auction_horse = @auction.horses.find(params[:id])
      authorize @auction_horse
    end

    def new
      @auction = Auction.find(params[:auction_id])
      horse = Horses::Horse.find(params[:horse])
      @auction_horse = @auction.horses.build(horse:)
      authorize @auction_horse
    end

    def edit
    end

    def create
      @auction = Auction.find(params[:auction_id])
      horse = Horses::Horse.find(auction_params[:horse_id])
      @auction_horse = @auction.horses.build(horse:)
      authorize @auction_horse

      result = Auctions::HorseCreator.new.create_horse(auction_id: @auction.id, horse_id: horse.id,
        stable_id: Current.stable.id, reserve_price: auction_params[:reserve_price], comment: auction_params[:comment])
      if result.created?
        flash[:success] = t(".success", horse: horse.name, auction: @auction.title)
        redirect_to horse_path(horse)
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("auction_form", partial: "auctions/horses/form", locals: { auction: @auction, horse: result.auction_horse })
          end
        end
      end
    end

    def update
    end

    def destroy
      @auction = Auction.find(params[:auction_id])
      horse = Horses::Horse.find(params[:id])
      @auction_horse = @auction.horses.find_by(horse:)
      authorize @auction_horse

      if @auction_horse.destroy!
        flash[:success] = t(".success", horse: horse.name, auction: @auction.title) # rubocop:disable Rails/ActionControllerFlashBeforeRender
        redirect_to horse_path(horse), success: t(".success")
      else
        flash[:error] = t(".failure", horse: horse.name, auction: @auction.title)
        respond_to do |format|
          format.turbo_stream { render :destroy }
          format.html { redirect_to horse_path(horse), error: t(".failure") }
        end
      end
    end

    private

    def auction_params
      params.expect(auctions_horse: [:horse_id, :comment, :reserve_price])
    end
  end
end

