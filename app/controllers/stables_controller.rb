class StablesController < AuthenticatedController
  skip_before_action :authenticate_user!, except: %i[edit update]
  skip_before_action :verify_active_user!, except: %i[edit update]

  def index
    authorize Account::Stable
    @stables = authorized_scope(Stables::List.run!)
  end

  def show
    @stable = load_stable
    authorize @stable
  end

  def edit
    stable = load_stable
    authorize stable

    @stable_form = Stables::UpdateDescription.new(stable:, description: stable.description)
  end

  def update
    stable = load_stable
    authorize stable
    outcome = Stables::UpdateDescription.run(update_params)

    if outcome.valid?
      success_message = t(".success")
      redirect_to current_stable_path, notice: success_message
    else
      @stable_form = outcome
      render :edit
    end
  end

  private

  def update_params
    { stable: current_stable }.reverse_merge(stable_params)
  end

  def stable_params
    params.expect(stable: [:description])
  end

  def load_stable
    params[:id] ? find_stable! : current_stable
  end

  def find_stable!
    outcome = Stables::Find.run(params)

    raise ActiveRecord::RecordNotFound, outcome.errors.full_messages.to_sentence unless outcome.valid?

    outcome.result
  end
end

