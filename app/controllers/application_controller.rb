require "browser/aliases"

class ApplicationController < ActionController::Base
  include Pagy::Method
  include Devise::Controllers::Helpers
  include DeviseHooks
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery prepend: true

  allow_browser versions: :modern
  impersonates :user, method: :current_user, with: ->(id) { Account::User.find_by(id:) }

  before_action :set_current_user
  before_action :setup_sentry
  before_action :set_variant
  before_action :update_stable_online, unless: :impersonating?

  around_action :switch_locale

  after_action :verify_pundit_authorization

  protected

  def not_found
    render "errors/not_found"
  end

  def user_not_authorized(exception)
    policy = exception.policy
    policy_name = policy.class.to_s.underscore

    error_key = policy.error_message_key || exception.query
    error_message_18n_params = policy.error_message_18n_params || {}

    msg = t("#{policy_name}.#{error_key}", scope: "pundit", default: :default, **error_message_18n_params)
    flash[:error] = msg # rubocop:disable Rails/ActionControllerFlashBeforeRender
    respond_to do |format|
      format.html { redirect_to(request.referer || root_path) }
      format.js { render js: } # e.g. use your standard js notify application }
    end
  end

  def verify_pundit_authorization
    return if devise_controller? || mission_control_controller?

    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  def mission_control_controller?
    is_a?(MissionControl::Jobs::ApplicationController)
  end

  def unauthorized_path
    root_path
  end

  def switch_locale(&)
    I18n.with_locale(wanted_locale, &)
  end

  def wanted_locale
    Accounts::CookieLocaleSyncer.new.call(cookies:)
    cookies[:locale] || Current.user.try(:locale) || I18n.default_locale
  end

  def setup_sentry
    return unless Current.user

    Sentry.set_user(username: Current.user.username)
  end

  def set_variant
    Browser::Base.include(Browser::Aliases)

    browser = Browser.new(request.user_agent)
    request.variant = if browser.mobile?
      :phone
    elsif browser.tablet?
      :tablet
    else
      :desktop
    end
  end

  def impersonating?
    true_user != Current.user
  end

  def update_stable_online
    SessionsRepository.update_last_online(stable: Current.stable)
  end

  def set_current_user
    return unless current_user

    Current.user = current_user
  end
end

