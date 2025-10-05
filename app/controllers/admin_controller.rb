class AdminController < AuthenticatedController
  skip_before_action :verify_active_user!
  skip_after_action :verify_pundit_authorization

  before_action :verify_admin!

  private

  def verify_admin!
    redirect_to root_path unless current_user.admin? || true_user&.admin?
  end
end

