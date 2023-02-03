class StablesController < ApplicationController
  attr_accessor :stables, :stable, :stable_form

  helper_method :stables, :stable, :stable_form

  before_action :load_stable, except: :index
  before_action :authenticate_user!, only: %i[show edit], unless: :stable
  before_action :verify_active_user!, only: :show, unless: :stable

  # @route GET /stables (stables)
  def index
    authorize Account::Stable
    self.stables = policy_scope(Stables::List.run!)
  end

  # @route GET /stables/:id (stable)
  # @route GET /stable (current_stable)
  # @route GET / (authenticated_root)
  def show
    authorize stable
  end

  # @route GET /stable/edit (edit_current_stable)
  def edit
    authorize stable

    @stable_form = Stables::UpdateDescription.new(stable:, description: stable.description)
  end

  # @route PUT /stable/edit (update_current_stable)
  # @route PATCH /stable/edit (update_current_stable)
  def update
    authorize stable
    outcome = Stables::UpdateDescription.run(update_params)

    if outcome.valid?
      flash[:notice] = t(".success")
      redirect_to current_stable_path
    else
      load_from_form(outcome)
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def update_params
      { stable: current_stable }.reverse_merge(stable_params)
    end

    def load_from_form(outcome)
      self.stable_form = outcome
      self.stable = outcome.stable
    end

    def stable_params
      params.require(:stable).permit(:description)
    end

    def load_stable
      self.stable = params[:id] ? find_stable! : current_stable
    end

    def find_stable!
      outcome = Stables::Find.run(params)

      raise ActiveRecord::RecordNotFound, outcome.errors.full_messages.to_sentence unless outcome.valid?

      outcome.result
    end
end

