class StablesController < AuthenticatedController
  include NonNumericIdOnly

  skip_before_action :authenticate_user!, only: %i[index show]
  skip_before_action :verify_active_user!, only: %i[index show]

  def index
    authorize Account::Stable
    @stables = policy_scope(Account::Stable).includes(:user).order(name: :asc)
  end

  def show
    @stable = params[:id] ? find_stable! : Current.stable
    authorize @stable
  end

  def edit
    @stable = Current.stable
    authorize @stable
  end

  def update
    @stable = Current.stable
    authorize @stable
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
    params.expect(account_stable: [:description])
  end

  def find_stable!
    Account::Stable.find(params[:id])
  end
end

