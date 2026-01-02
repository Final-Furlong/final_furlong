class StablesController < AuthenticatedController
  include NonNumericIdOnly

  skip_before_action :authenticate_user!, only: %i[index show]
  skip_before_action :verify_active_user!, only: %i[index show]

  def index
    authorize Account::Stable
    @stables = policy_scope(Account::Stable).order(name: :asc)
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
      flash[:success] = t(".success")
      redirect_to current_stable_path
    else
      @stable_form = outcome
      render :edit
    end
  end

  private

  def update_params
    { stable: Current.stable }.reverse_merge(stable_params)
  end

  def stable_params
    params.expect(stable: [:description])
  end

  def load_stable
    params[:id] ? find_stable! : Current.stable
  end

  def find_stable!
    Account::Stable.find(params[:id])
  end
end

