class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Devise::Controllers::Helpers
  include Pundit::Authorization
  impersonates :user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :setup_sentry

  around_action :switch_locale

  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  protected

  def user_not_authorized
    flash[:alert] = I18n.t("errors.not_authorized", locale: wanted_locale)

    redirect_to root_path
  end

  def current_stable
    @current_stable ||= current_user.stable if signed_in?
  end

  helper_method :current_stable

  def switch_locale(&)
    I18n.with_locale(wanted_locale, &)
  end

  def wanted_locale
    Users::SyncLocale.run(user: current_user, cookies:)
    cookies[:locale] || current_user.try(:locale) || I18n.default_locale
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
    %i[username name email password password_confirmation current_password]
  end

  def sign_up_keys
    [:username, :email, :name, :password, :password_confirmation, { stable_attributes: [:name] }]
  end

  def setup_sentry
    return unless current_user

    Sentry.set_user(username: current_user.username)
  end
end
