class HorsesController < ApplicationController
  before_action :set_horse, except: :index
  before_action :authorize_horse, except: :index

  attr_accessor :horses, :horse, :statuses, :active_status, :query

  helper_method :horses, :horse, :statuses, :active_status, :query, :params

  # @route GET /horses (horses)
  def index
    authorize Horse

    # ActionController::Parameters.permit_all_parameters = true
    set_active_status
    @query = policy_scope(Horse).includes(:owner).ransack(params[:q])
    query.sorts = "name asc" if query.sorts.blank?

    @horses = query.result.page(params[:page])
    @statuses = Horse.where.not(status: "unborn").group(:status).count
  end

  # @route GET /horses/:id (horse)
  def show; end

  # @route GET /horses/:id/edit (edit_horse)
  def edit; end

  # @route PATCH /horses/:id (horse)
  # @route PUT /horses/:id (horse)
  def update
    if @horse.update(horse_params)
      @horse.reload
      respond_to do |format|
        format.html { redirect_to horses_path, notice: t(".success", name: @horse.name) }
        format.turbo_stream { flash.now[:success] = t(".success", name: @horse.name) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def authorize_horse
      authorize @horse
    end

    def set_horse
      @horse = Horse.find(params[:id])
    end

    def horse_params
      params.require(:horse).permit(:name, :date_of_birth)
    end

    def set_active_status
      if params.dig(:q, :status_in)
        @active_status = :retired
      elsif params.dig(:q, :status_eq)
        @active_status = params.dig(:q, :status_eq).to_sym
      else
        @active_status = :racehorse
        params[:q] ||= {}
        params[:q][:status_eq] = :racehorse
      end
    end
end

