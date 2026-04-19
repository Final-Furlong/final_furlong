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

        new_status = Horses::Status::ACTIVE_BREEDING_STATUSES.include?(@horse.status) ? "retired_#{@horse.status}" : status_params[:status]
        if @horse.update(status: new_status)
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

