module Horse
  class JumpersController < AuthenticatedController
    def update
      horse = Horses::Horse.managed_by(Current.stable).find(params[:id])
      authorize horse, :switch_to_jumps?, policy_class: CurrentStable::RacehorsePolicy

      result = Horses::Racing::SteeplechaseSwitcher.new.switch_to_steeplechase(horse:)
      if result.saved?
        flash[:success] = t(".success", name: horse.name)
      else
        flash[:error] = t(".failure", name: horse.name)
      end
      redirect_to horse_path(horse)
    end
  end
end

