class UsersController < AuthenticatedController
  before_action :load_user, only: %i[show edit update destroy]
  before_action :new_user, only: %i[new create]
  before_action :load_new_user_form, only: %i[new create]
  before_action :load_edit_user_form, only: %i[edit update]
  before_action :authorize_user, except: :index

  # @route GET /users (users)
  def index
    authorize User
    @users = authorized_scope(User).ordered
  end

  # @route GET /users/:id (user)
  def show
  end

  # @route GET /users/new (new_user)
  def new
  end

  # @route GET /users/:id/edit (edit_user)
  def edit
  end

  # @route POST /users (users)
  def create
    if @user_form.submit(user_attributes)
      flash[:success] = t(".success")
      redirect_to users_path
    else
      flash[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  # @route PATCH /users/:id (user)
  # @route PUT /users/:id (user)
  def update
    if @user_form.submit(user_attributes)
      flash[:success] = t(".success")
      redirect_to users_path
    else
      flash[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  # @route DELETE /users/:id (user)
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
    @user = User.find_by(id: params[:id])
  end

  def new_user
    @user = User.new
  end

  def load_new_user_form
    @user_form = Users::NewUserForm.new(@user)
  end

  def load_edit_user_form
    @user_form = Users::UpdateUserForm.new(@user)
  end

  def user_attributes
    permitted_attributes(@user)
  end
end

