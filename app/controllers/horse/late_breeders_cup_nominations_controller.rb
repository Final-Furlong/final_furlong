module Horse
  class LateBreedersCupNominationsController < AuthenticatedController
    def new
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :late_nominate?, policy_class: CurrentStable::RacehorsePolicy
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :late_nominate?, policy_class: CurrentStable::RacehorsePolicy

      result = Racing::LateBreedersCupNominator.new.create_nomination(horse: @horse, stable: Current.stable)
      if result.created?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        respond_to do |format|
          format.html { redirect_to horse_path(@horse), error: result.error }
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("nomination-form", partial: "horse/late_breeders_cup_nominations/form", locals: { horse: @horse, error: result.error })
          end
        end
      end
    end
  end
end

