module Horse
  class LeaseOffersController < ApplicationController
    def new
      horse = Horses::Horse.find(params[:id])
      authorize horse, :create_lease_offer?, policy_class: CurrentStable::HorsePolicy

      @lease_offer = horse.lease_offer || horse.build_lease_offer
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :create_lease_offer?, policy_class: CurrentStable::HorsePolicy

      result = Horses::LeaseOfferCreator.new.create_offer(horse: @horse, params: lease_params)
      @lease_offer = result.offer
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        flash[:error] = t("common.failed_validation")
        render :new
      end
    end

    def destroy
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :destroy_lease_offer?, policy_class: CurrentStable::HorsePolicy

      if @horse.lease_offer.destroy!
        flash[:success] = t(".success")
      end

      redirect_to horse_path(@horse)
    end

    private

    def lease_params
      params.expect(horses_lease_offer: [:offer_start_date, :duration_months, :leaser_id, :member_type, :fee])
    end
  end
end

