require "browser/aliases"

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Devise::Controllers::Helpers
  include DeviseHooks
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  impersonates :user, method: :current_user, with: ->(id) { Account::User.find_by(id:) }

  protect_from_forgery prepend: true

  before_action :setup_sentry
  before_action :set_variant
  before_action :update_stable_online, unless: :impersonating?

  around_action :switch_locale

  after_action :verify_pundit_authorization

  helper_method :current_stable

  protected

  def not_found
    render "errors/not_found"
  end

  def user_not_authorized
    flash[:alert] = I18n.t("errors.not_authorized", locale: wanted_locale)

    redirect_to unauthorized_path
  end

  def verify_pundit_authorization
    return if devise_controller?
    Rails.logger.info "DEBUG CONTROLLER NAME: #{controller_name}"

    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  def unauthorized_path
    root_path
  end

  def current_stable
    return unless signed_in?

    @current_stable ||= current_user.stable
  end

  def switch_locale(&)
    I18n.with_locale(wanted_locale, &)
  end

  def wanted_locale
    Users::SyncLocale.run(user: current_user, cookies:)
    cookies[:locale] || current_user.try(:locale) || I18n.default_locale
  end

  def setup_sentry
    return unless current_user

    Sentry.set_user(username: current_user.username)
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
    true_user != current_user
  end

  def update_stable_online
    SessionsRepository.update_last_online(stable: current_stable)
  end
end

