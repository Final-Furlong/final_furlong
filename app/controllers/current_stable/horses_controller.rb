module CurrentStable
  class HorsesController < AuthenticatedController
    before_action :set_horse, except: :index

    # @route GET /stable/horses (stable_horses)
    def index
      @horses = authorized_scope(Horses::Horse, type: :relation, with: CurrentStable::HorsePolicy)
    end

    # @route GET /stable/horses/:id (stable_horse)
    def show
    end

    # @route GET /stable/horses/:id/edit (edit_stable_horse)
    def edit
    end

    # @route PATCH /stable/horses/:id (stable_horse)
    # @route PUT /stable/horses/:id (stable_horse)
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
      params.require(:horse).permit(:name)
    end
  end
end

