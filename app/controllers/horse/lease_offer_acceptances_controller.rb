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
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("messages", partial: "layouts/flash")
          end
        end
      end
    end
  end
end

