require "browser/aliases"

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Devise::Controllers::Helpers
  include DeviseHooks

  impersonates :user, method: :current_user, with: ->(id) { Account::User.find_by(id:) }

  rescue_from ActionPolicy::Unauthorized, with: :user_not_authorized

  protect_from_forgery prepend: true

  before_action :setup_sentry
  before_action :set_variant
  before_action :update_stable_online

  around_action :switch_locale

  after_action :verify_authorized, except: :index, unless: :devise_controller?

  helper_method :current_stable

  protected

  def authorize(record, rule = nil)
    options = {}
    options[:to] = rule unless rule.nil?

    authorize! record, **options
  end

  def user_not_authorized(exception)
    flash[:alert] = if exception.result.reasons.full_messages
      exception.result.reasons.full_messages.join(", ")
    else
      I18n.t("errors.not_authorized", locale: wanted_locale)
    end

    redirect_to unauthorized_path
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

  def update_stable_online
    return unless current_stable
    return if true_user != current_user # impersonating this stable
    return if current_stable.last_online_at && current_stable.last_online_at > 15.minutes.ago

    current_stable.update_columns(last_online_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
  end
end

