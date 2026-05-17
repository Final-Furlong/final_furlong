module Horse
  class SupplementalBreedersCupNominationsController < AuthenticatedController
    def new
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :late_nominate?, policy_class: CurrentStable::RacehorsePolicy
      @race = Racing::RaceSchedule.find(params[:race])
    end

    def create
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :late_nominate?, policy_class: CurrentStable::RacehorsePolicy
      @race = Racing::RaceSchedule.find(nomination_params[:race_id])

      result = Racing::SupplementalBreedersCupNominator.new.create_nomination(horse: @horse, stable: Current.stable, race: @race)
      if result.created?
        flash[:success] = t(".success", name: @horse.name, year: Date.current.year, race: @race.name)
        redirect_to horse_path(@horse)
      else
        respond_to do |format|
          format.html { redirect_to horse_path(@horse), error: result.error }
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("nomination-form", partial: "horse/supplemental_breeders_cup_nominations/form", locals: { horse: @horse, race: @race, error: result.error })
          end
        end
      end
    end

    private

    def nomination_params
      params.expect(nomination: [:race_id])
    end
  end
end

