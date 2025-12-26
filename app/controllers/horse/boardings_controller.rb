module Horse
  class BoardingsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:id])
      authorize horse, :view_boarding?, policy_class: CurrentStable::HorsePolicy

      @dashboard = Dashboard::Horse::Boarding.new(horse:)
      render "horse/events/boardings"
    end

    def destroy
      @boarding = Horses::Boarding.find(params[:id])
      authorize @boarding

      result = Horses::BoardingUpdater.new.stop_boarding(boarding: @boarding)
      if result.updated?
        flash[:success] = t(".success") # rubocop:disable Rails/ActionControllerFlashBeforeRender
      else
        flash[:error] = result.error
      end
      respond_to do |format|
        format.turbo_stream { render :destroy }
        format.html { redirect_to horse_path(@boarding.horse), success: t(".success") }
      end
    end
  end
end

