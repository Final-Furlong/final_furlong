# typed: strict

class UsersController < AuthenticatedController
  before_action :set_user, only: %i[show edit update destroy]

  sig { returns(User::ActiveRecord_Relation) }
  # @route GET /users (users)
  def index
    @users = T.must(@users = T.let(User.active.ordered, T.nilable(User::ActiveRecord_Relation)))
  end

  sig { returns(NilClass) }
  # @route GET /users/:id (user)
  def show; end

  sig { returns(User) }
  # @route GET /users/new (new_user)
  def new
    @user = User.new
  end

  sig { void }
  # @route POST /users (users)
  def create
    @user = User.new(create_params)
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

  sig { void }
  # @route PATCH /users/:id (user)
  # @route PUT /users/:id (user)
  def update
    @user = T.must(@user)
    if @user.update(update_params)
      redirect_to users_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  sig { void }
  # @route DELETE /users/:id (user)
  def destroy
    # TODO: fix this when enum statuses work properly
    # T.must(@user).deleted!
    T.must(@user).update!(status: "deleted")
    flash[:notice] = t(".success")
    respond_to do |format|
      format.html { redirect_to users_path, notice: t(".success") }
      format.turbo_stream
    end
  end

  private

  sig { returns(T.nilable(User)) }
  def set_user
    @user = T.let(User.find_by(id: params[:id]), T.nilable(User))
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def create_params
    user_policy.permitted_attributes_for_create(params[:user])
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def update_params
    user_policy.permitted_attributes_for_edit(params[:user])
  end

  sig { returns(UserPolicy) }
  def user_policy
    Pundit.policy!(current_user, @user || User.new)
  end
end
