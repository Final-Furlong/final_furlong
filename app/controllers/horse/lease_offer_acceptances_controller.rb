module Horse
  class LeaseOfferAcceptancesController < ApplicationController
    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :accept_lease_offer?, policy_class: CurrentStable::HorsePolicy

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

