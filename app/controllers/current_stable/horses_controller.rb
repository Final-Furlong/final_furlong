module CurrentStable
  class HorsesController < AuthenticatedController
    before_action :set_horse, except: :index

    def index
      @horses = authorized_scope(Horses::Horse, type: :relation, with: CurrentStable::HorsePolicy)
    end

    def show
    end

    def edit
    end

    def update
      if @horse.update(horse_params)
        redirect_to stable_horses_path, notice: t(".success", name: @horse.name)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_horse
      @horse = current_stable.horses.find(params[:id])
    end

    def horse_params
      params.expect(horse: [:name])
    end
  end
end

