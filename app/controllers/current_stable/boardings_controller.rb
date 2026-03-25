module CurrentStable
  class BoardingsController < ::AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      authorize %i[current_stable boarding]
    end

    def new
      authorize %i[current_stable boarding]
      @boarding = Horses::Boarding.new
    end

    def create
      authorize %i[current_stable boarding]
      @boarding = Horses::Boarding.new
      horse = Horses::Horse.racehorse.managed_by(Current.stable).find(boarding_params[:horse_id])

      result = Horses::BoardingCreator.new.start_boarding(horse:)
      if result.created?
        flash[:success] = t(".success")
        redirect_to stable_boardings_path
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("boarding-form", partial: "current_stable/boardings/form", locals: { boarding: @boarding })
          end
        end
      end
    end

    def update
      boarding = Horses::Boarding.find(params[:id])
      authorize boarding, policy_class: CurrentStable::BoardingPolicy

      result = Horses::BoardingUpdater.new.stop_boarding(boarding:)
      if result.updated?
        flash[:success] = t(".success")
      else
        flash[:error] = t(".failure")
      end
      redirect_to stable_boardings_path
    end

    private

    def boarding_params
      params.expect(horses_boarding: [:horse_id])
    end
  end
end

