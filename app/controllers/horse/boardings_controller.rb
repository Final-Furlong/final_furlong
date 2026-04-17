module Horse
  class BoardingsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      horse = Horses::Horse.find(params[:horse_id])
      authorize horse, :view_boarding?, policy_class: CurrentStable::HorsePolicy

      @dashboard = Dashboard::Horse::Boarding.new(horse:)
      render "horse/events/boardings"
    end

    def new
      horse = Horses::Horse.find(params[:horse_id])
      @boarding = Horses::Boarding.new(horse:)
      authorize @boarding
    end

    def create
      horse = Horses::Horse.find(params[:horse_id])
      @boarding = Horses::Boarding.new(horse:)
      authorize @boarding

      result = Horses::BoardingCreator.new.start_boarding(horse:)
      if result.created?
        flash[:success] = t(".success")
        redirect_to stable_boardings_path
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("boarding-form", partial: "horse/boardings/form", locals: { boarding: @boarding, horse: })
          end
        end
      end
    end

    def destroy
      horse = Horses::Horse.find(params[:horse_id])
      @boarding = Horses::Boarding.find_by(horse:, id: params[:id])
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

