module Admin
  class ImpersonatesController < ApplicationController
    skip_after_action :verify_authorized, only: :destroy

    # @route POST /admin/impersonate (admin_impersonate)
    def create
      user = User.find(params[:id])
      authorize user

      impersonate_user(user)
      redirect_to root_path
    end

    # @route GET /admin/impersonate (admin_impersonate)
    def show; end

    # @route DELETE /admin/impersonate (admin_impersonate)
    def destroy
      stop_impersonating_user
      flash[:notice] = t("users.stop_impersonating.success")
      redirect_to root_path
    end
  end
end

