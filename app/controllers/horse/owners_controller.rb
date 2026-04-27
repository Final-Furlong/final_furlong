module Horse
  class OwnersController < AuthenticatedController
    def update
      horse = Horses::Horse.managed_by(Current.stable).find(params[:id])
      authorize horse, :give_to_game?, policy_class: CurrentStable::HorsePolicy

      result = Horses::OwnerUpdater.new.transfer_to_game(horse:, stable: Current.stable)
      if result.saved?
        flash[:success] = t(".success")
      else
        flash[:error] = t(".failure")
      end
      redirect_to horse_path(horse)
    end
  end
end

