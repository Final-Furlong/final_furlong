class UsersController < AuthenticatedController
  include NonNumericIdOnly

  def index
    authorize Account::User
    @users = policy_scope(Account::User)
  end

  def show
    @user = Account::User.find(params[:id])
    authorize @user
  end

  def edit
    @user = Current.user
    authorize @user
  end

  def update
    @user = Current.user
    authorize @user
    if @user.update(user_params)
      flash[:success] = t(".success")
      redirect_to root_path
    else
      flash[:alert] = t(".failure")
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("user-form", partial: "users/form", locals: { user: @user })
        end
      end
    end
  end

  private

  def user_params
    params.expect(account_user: %i[name email])
  end
end

