# typed: true

class HorsesController < ApplicationController
  before_action :set_horse, except: :index

  # @route GET /horses (horses)
  def index
    @horses = Horse.living.ordered
    @controller = params[:controller]
    @action = params[:action]
  end

  sig { returns(NilClass) }
  # @route GET /horses/:id (horse)
  def show; end

  sig { returns(NilClass) }
  # @route GET /horses/:id/edit (edit_horse)
  def edit; end

  # @route PATCH /horses/:id (horse)
  # @route PUT /horses/:id (horse)
  def update
    if @horse.update(horse_params)
      @horse.reload
      respond_to do |format|
        format.html { redirect_to horses_path, notice: t(".success", name: @horse.name) }
        format.turbo_stream { flash.now[:notice] = t(".success", name: @horse.name) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_horse
    @horse = Horse.find(params[:id])
  end

  def horse_params
    params.require(:horse).permit(:name, :date_of_birth)
  end
end
