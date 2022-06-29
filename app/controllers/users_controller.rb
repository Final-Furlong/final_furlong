# typed: true

class UsersController < AuthenticatedController
  before_action :set_user, only: %i[show edit update destroy]

  # @route GET /users (users)
  def index
    @users = User.active.ordered
  end

  sig { returns(NilClass) }
  # @route GET /users/:id (user)
  def show; end

  sig { returns(User) }
  # @route GET /users/new (new_user)
  def new
    @user = User.new
  end

  # @route POST /users (users)
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = t(".success")
      respond_to do |format|
        format.html { redirect_to users_path }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  sig { returns(NilClass) }
  # @route GET /users/:id/edit (edit_user)
  def edit; end

  # @route PATCH /users/:id (user)
  # @route PUT /users/:id (user)
  def update
    if @user.update(user_params)
      redirect_to users_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /users/:id (user)
  def destroy
    @user.deleted!
    flash[:notice] = t(".success")
    respond_to do |format|
      format.html { redirect_to users_path, notice: t(".success") }
      format.turbo_stream
    end
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
  end
end
