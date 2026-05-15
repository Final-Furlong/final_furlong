module Horse
  class StudNominationsController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      @horse = Horses::Horse.find(params[:id])
      @dashboard = Dashboard::Horse::StudNomination.new(horse: @horse)
    end

    def new
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :nominate?, policy_class: CurrentStable::StallionPolicy
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :nominate?, policy_class: CurrentStable::StallionPolicy

      result = Stud::BreedersCupNominator.new.create_nomination(horse: @horse, stable: Current.stable)
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        respond_to do |format|
          format.html { redirect_to horse_path(@horse), error: result.error }
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("nomination-form", partial: "horse/stud_nominations/form", locals: { horse: @horse, error: result.error })
          end
        end
      end
    end
  end
end

