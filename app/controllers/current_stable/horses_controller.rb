module CurrentStable
  class HorsesController < AuthenticatedController
    def index
      @horses = policy_scope(Horses::Horse, policy_scope_class: CurrentStable::HorsePolicy::Scope)
    end

    def show
      @horse = current_stable.horses.find(params[:id])
      authorize @horse, policy_class: CurrentStable::HorsePolicy
    end

    def edit
      @horse = current_stable.horses.find(params[:id])
    end

    def update
      if @horse.update(horse_params)
        redirect_to stable_horses_path, notice: t(".success", name: @horse.name)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def horse_params
      params.expect(horse: [:name])
    end
  end
end

