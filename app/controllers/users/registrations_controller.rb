module Users
  class RegistrationsController < Devise::RegistrationsController
    # @route GET /join (new_user_registration)
    def new
      redirect_to new_user_session_path and return
      super
    end
  end
end
