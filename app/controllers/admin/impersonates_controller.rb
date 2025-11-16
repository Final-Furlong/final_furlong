module Admin
  class ImpersonatesController < AdminController
    def create
      user = Account::User.find(params[:id])
      authorize user.stable, :impersonate?, policy_class: Account::StablePolicy

      impersonate_user(user)
      reset_pundit
      redirect_to root_path
    end

    def destroy
      stop_impersonating_user
      reset_pundit
      flash[:notice] = t("users.stop_impersonating.success")
      redirect_to root_path
    end

    private

    def reset_pundit
      pundit_reset!
    end
  end
end

