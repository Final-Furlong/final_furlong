module CurrentStable
  class HorsesController < BaseController
    before_action :set_horse, except: :index

    # @route GET /stable/horses (current_stable_horses)
    def index
      @horses = policy_scope(Horse)
    end

    # @route GET /stable/horses/:id (current_stable_horse)
    def show; end

    # @route GET /stable/horses/:id/edit (edit_current_stable_horse)
    def edit; end

    # @route PUT /stable/horses/:id (update_current_stable_horse)
    # @route PATCH /stable/horses/:id (update_current_stable_horse)
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
