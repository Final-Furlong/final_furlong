module Users
  class SessionsController < Devise::SessionsController
    def new
      redirect_to sso_login_path and return
    end

    def destroy
      super
      set_flash_success
    end

    private

    def set_flash_success
      return unless flash[:notice]

      flash[:success] = flash[:notice]
      flash[:notice] = nil
    end
  end
end

