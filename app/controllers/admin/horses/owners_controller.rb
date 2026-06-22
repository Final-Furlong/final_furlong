module Admin::Horses
  class OwnersController < AuthenticatedController
    def edit
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :change_owner?, policy_class: CurrentStable::HorsePolicy
    end

    def update
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :change_owner?, policy_class: CurrentStable::HorsePolicy

      result = Admin::HorseOwnerUpdater.new.update_owner(horse: @horse, stable_id: sale_params[:owner_id])
      if result.saved?
        flash[:success] = t(".success")
      else
        flash[:error] = t(".failure")
      end
      redirect_to horse_path(@horse)
    end

    private

    def sale_params
      params.expect(horses_horse: [:owner_id])
    end
  end
end

