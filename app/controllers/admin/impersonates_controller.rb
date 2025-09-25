module Admin
  class ImpersonatesController < ApplicationController
    def create
      user = Account::User.find(params[:id])
      authorize user

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

