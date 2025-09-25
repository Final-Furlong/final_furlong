module Users
  class RegistrationsController < Devise::RegistrationsController
    def new
      redirect_to new_user_session_path and return
      super
    end
  end
end

