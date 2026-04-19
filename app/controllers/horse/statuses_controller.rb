module Horse
  class StatusesController < AuthenticatedController
    def edit
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :change_status?, policy_class: CurrentStable::HorsePolicy
    end

    def update
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :change_status?, policy_class: CurrentStable::HorsePolicy

      if status_params[:status]
        authorize @horse, "status_#{status_params[:status]}?", policy_class: CurrentStable::HorsePolicy

        result = Horses::StatusUpdater.new.update_status(horse: @horse, status: status_params[:status])
        if result.updated?
          flash[:success] = t(".success", name: @horse.name, status: status_params[:status].titleize)
          redirect_to horse_path(@horse)
        else
          flash[:failure] = t(".failure", name: @horse.name, status: status_params[:status].titleize)
          respond_to do |format|
            format.html { render :edit, status: :unprocessable_entity }
            format.turbo_stream do
              render turbo_stream: turbo_stream.replace("status-form", partial:, locals: { horse: @horse })
            end
          end
        end
      end
    end

    private

    def status_params
      params.expect(horses_horse: [:status])
    end
  end
end

