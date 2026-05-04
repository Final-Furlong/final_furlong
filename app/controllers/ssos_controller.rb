class SSOsController < ApplicationController
  include Devise::Controllers::SignInOut

  prepend_before_action(only: :show) { request.env["devise.skip_timeout"] = true }
  skip_after_action :verify_pundit_authorization, only: :show

  def show
    handler = Game::SSOHandler.new
    if handler.hex_digest(params[:sso]) == params[:sig]
      if handler.base64? params[:sso]
        decoded_hash = handler.decoded_hash(params[:sso])
        if decoded_hash[:nonce] == session[:sso_nonce]
          decoded_hash.delete(:nonce)
          user_info = decoded_hash
          user = Account::User.find_by(email: user_info[:email])
          sign_in user
          status = "success"
        else
          status = "error"
          message = t(".nonce_mismatch")
        end
      else
        status = "error"
        message = t(".not_base64")
      end
    else
      status = "error"
      message = t(".hmac_mismatch")
    end

    if status == "success"
      flash[:success] = t(".success")
      redirect_to current_stable_path
    else
      flash[:error] = message
      redirect_to root_path
    end
  end
end

