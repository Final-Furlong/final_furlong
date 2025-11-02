class UsersController < AuthenticatedController
  include NonNumericIdOnly

  before_action :load_user, only: %i[show edit update destroy]
  before_action :new_user, only: %i[new create]
  before_action :load_new_user_form, only: %i[new create]
  before_action :load_edit_user_form, only: %i[edit update]
  before_action :authorize_user, except: :index

  def index
    authorize Account::User
    @users = policy_scope(Account::User)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @user_form.save(user_attributes)
      redirect_to_users
    else
      flash[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user_form.submit(user_attributes)
      redirect_to_users
    else
      flash[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user.deleted!
    flash[:success] = t(".success")
    respond_to do |format|
      format.html { redirect_to users_path, notice: t(".success") }
      format.turbo_stream
    end
  end

  private

  def authorize_user
    authorize @user
  end

  def load_user
    @user = Account::User.find_by(id: params[:id])
  end

  def new_user
    @user = Account::User.new
  end

  def load_new_user_form
    @user_form = Users::NewUserForm.new(user_attributes)
  end

  def load_edit_user_form
    @user_form = Users::UpdateUserForm.new(@user)
  end

  def user_attributes
    permitted_attributes(@user)
  end

  def redirect_to_users
    flash[:success] = t(".success")
    redirect_to users_path
  end
end

