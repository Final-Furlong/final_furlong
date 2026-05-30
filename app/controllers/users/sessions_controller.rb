module Users
  class SessionsController < Devise::SessionsController
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

