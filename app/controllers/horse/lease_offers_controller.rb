module Horse
  class LeaseOffersController < ApplicationController
    def new
      horse = Horses::Horse.find(params[:id])
      authorize horse, :create_lease_offer?, policy_class: CurrentStable::LeaseOfferPolicy

      @lease_offer = horse.lease_offer || horse.build_lease_offer
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :create_lease_offer?, policy_class: CurrentStable::LeaseOfferPolicy

      result = Horses::LeaseOfferCreator.new.create_offer(horse: @horse, params: lease_params)
      @lease_offer = result.offer
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("lease-offer-form", partial: "horse/lease_offers/form", locals: { lease_offer: @lease_offer, horse: @horse })
          end
        end
      end
    end

    def destroy
      @horse = Horses::Horse.find(params[:id])
      offer = @horse.lease_offer
      authorize offer, :destroy?, policy_class: CurrentStable::LeaseOfferPolicy
      leaser = offer.leaser

      ActiveRecord::Base.transaction do
        if offer.destroy!
          create_owner_notification(@horse, offer, leaser) if Current.stable == leaser
        end
        flash[:success] = t(".success") # rubocop:disable Rails/ActionControllerFlashBeforeRender
      end
      respond_to do |format|
        format.turbo_stream { render :destroy }
        format.html { redirect_to horse_path(@horse), success: t(".success") }
      end
    end

    private

    def create_owner_notification(horse, offer, leaser)
      Game::NotificationCreator.new.create_notification(
        type: ::LeaseRejectionNotification,
        user: horse.owner.user,
        params: {
          offer_id: offer.id,
          horse_id: horse.slug,
          horse_name: horse.name,
          stable_name: leaser.name,
          fee: Game::MoneyFormatter.new(offer.fee).to_s
        }
      )
    end

    def lease_params
      params.expect(horses_lease_offer: [:offer_start_date, :duration_months, :leaser_id, :member_type, :fee])
    end
  end
end

