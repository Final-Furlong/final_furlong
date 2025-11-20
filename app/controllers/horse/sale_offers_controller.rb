module Horse
  class SaleOffersController < ApplicationController
    def new
      horse = Horses::Horse.find(params[:id])
      @sale_offer = horse.sale_offer || horse.build_sale_offer

      authorize @sale_offer, :create?, policy_class: CurrentStable::SaleOfferPolicy
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      sale_offer = @horse.sale_offer || @horse.build_sale_offer
      authorize sale_offer, :create?, policy_class: CurrentStable::SaleOfferPolicy

      result = Horses::SaleOfferCreator.new.create_offer(horse: @horse, params: sale_params)
      @sale_offer = result.offer
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("sale-offer-form", partial: "horse/sale_offers/form", locals: { sale_offer: @sale_offer, horse: @horse })
          end
        end
      end
    end

    def destroy
      @horse = Horses::Horse.find(params[:id])
      offer = @horse.sale_offer
      authorize offer, :destroy?, policy_class: CurrentStable::SaleOfferPolicy
      buyer = offer.buyer

      ActiveRecord::Base.transaction do
        if offer.destroy!
          create_owner_notification(@horse, offer, buyer) if Current.stable == buyer
        end
        flash[:success] = t(".success") # rubocop:disable Rails/ActionControllerFlashBeforeRender
      end
      respond_to do |format|
        format.turbo_stream { render :destroy }
        format.html { redirect_to horse_path(@horse), success: t(".success") }
      end
    end

    private

    def create_owner_notification(horse, offer, buyer)
      Game::NotificationCreator.new.create_notification(
        type: ::SaleRejectionNotification,
        user: horse.owner.user,
        params: {
          offer_id: offer.id,
          horse_id: horse.slug,
          horse_name: horse.name,
          stable_name: buyer.name,
          price: Game::MoneyFormatter.new(offer.price).to_s
        }
      )
    end

    def sale_params
      params.expect(horses_sale_offer: [:offer_start_date, :buyer_id, :member_type, :price])
    end
  end
end

