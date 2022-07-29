class StablesController < ApplicationController
  attr_accessor :stables, :stable, :stable_form

  helper_method :stables, :stable, :stable_form

  before_action :load_stable, except: :index
  before_action :authenticate_user!, only: :show, unless: :stable
  before_action :verify_active_user!, only: :show, unless: :stable

  # @route GET /stables (stables)
  def index
    authorize Stable
    self.stables = policy_scope(Stable).ordered
  end

  # @route GET /stables/:id (stable)
  # @route GET /stable (current_stable)
  def show
    authorize stable
  end

  # @route GET /stables/:id/edit (edit_stable)
  def edit
    authorize stable
    @stable_form = Stables::UpdateForm.new(stable)
  end

  # @route PATCH /stables/:id (stable)
  # @route PUT /stables/:id (stable)
  def update
    authorize stable

    if @stable.update!(stable_params)
      redirect_to current_stable_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def stable_params
    params.require(:stable).permit(:description)
  end

  def load_stable
    self.stable = params[:id] ? Stable.find(params[:id]) : current_stable
  end
end
