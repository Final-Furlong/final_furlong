module Users
  class SessionsController < Devise::SessionsController
    # this override is just to get success messages instead of notice ones
    def new
      super
      set_flash_success
    end

    # POST /resource/sign_in
    def create
      super
      set_flash_success
    end

    # DELETE /resource/sign_out
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

