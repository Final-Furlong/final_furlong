class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  def set_locale
    # TODO: set this per user
    I18n.locale = :en
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_keys)
    devise_parameter_sanitizer.permit(:sign_in, keys: sign_in_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: account_update_keys)
  end

  def sign_in_keys
    %i[login password password_confirmation]
  end

  def account_update_keys
    %i[username name email password_confirmation current_password]
  end

  def sign_up_keys
    [:username, :email, :name, :password, :password_confirmation, { stable_attributes: [:name] }]
  end

  def current_stable
    return unless current_user

    current_user.stable
  end
end
