class SSOsController < ApplicationController
  include Devise::Controllers::SignInOut

  prepend_before_action(only: :show) { request.env["devise.skip_timeout"] = true }
  skip_after_action :verify_pundit_authorization, only: :show

  def show
    if get_hmac_hex_string(params[:sso]) == params[:sig]
      if base64? params[:sso]
        decoded_hash = Rack::Utils.parse_query(Base64.decode64(params[:sso]))
        decoded_hash.symbolize_keys!
        if decoded_hash[:nonce] == session[:sso_nonce]
          decoded_hash.delete(:nonce)
          user_info = decoded_hash
          user = Account::User.find_by(email: user_info[:email])
          sign_in user
          @status = "success"
        else
          @status = "error"
          @message = t(".nonce_mismatch")
        end
      else
        @status = "error"
        @message = t(".not_base64")
      end
    else
      @status = "error"
      @message = t(".hmac_mismatch")
    end

    if @status == "success"
      flash[:success] = t(".success")
      redirect_to current_stable_path
    else
      flash[:error] = @message
      redirect_to root_path
    end
  end

  private

  def get_hmac_hex_string(value)
    OpenSSL::HMAC.hexdigest("SHA256", Rails.application.credentials.dig(:discourse_sso_key), value).downcase
  end

  def base64? data
    !(data =~ /[^a-zA-Z0-9=\r\n\/+]/m)
  end
end

