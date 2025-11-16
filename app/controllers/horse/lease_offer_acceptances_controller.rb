module Horse
  class LeaseOfferAcceptancesController < ApplicationController
    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse.lease_offer, :accept?, policy_class: CurrentStable::LeaseOfferPolicy

      result = Horses::LeaseCreator.new.accept_offer(horse: @horse, stable: Current.stable)
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        flash[:error] = t("common.failed_validation")
        render :new
      end
    end
  end
end

