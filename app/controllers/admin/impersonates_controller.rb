module Admin
  class ImpersonatesController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :destroy

    def create
      user = Account::User.find(params[:id])
      authorize user.stable, :impersonate?, policy_class: Account::StablePolicy

      impersonate_user(user)
      redirect_to root_path
    end

    def destroy
      stop_impersonating_user
      flash[:notice] = t("users.stop_impersonating.success")
      redirect_to root_path
    end
  end
end

