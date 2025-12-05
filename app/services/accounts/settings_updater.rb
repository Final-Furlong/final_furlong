module Accounts
  class SettingsUpdater
    attr_reader :locale, :cookies, :setting

    def call(params:, cookies: nil)
      user = Current.user
      @cookies = cookies
      result = Result.new

      if user
        @setting = user.setting || user.build_setting
        set_attributes(params:)
        result.locale = locale
        if setting.save
          save_permanent_cookies(setting[:website], params)
          result.updated = true
        else
          result.updated = false
          result.error = setting.errors.full_messages.to_sentence
        end
        result.setting = setting
      else
        save_temporary_cookie(params:)
        result.locale = cookies[:locale]
        result.updated = true
      end
      result
    end

    class Result
      attr_accessor :updated, :setting, :locale, :error

      def initialize(locale: nil, error: nil)
        @setting = nil
        @locale = locale
        @updated = false
        @error = error
      end

      def updated?
        @updated
      end
    end

    private

    def set_attributes(params:)
      attrs = params[:website_attributes]
      if attrs
        setting.website[:locale] = attrs[:locale]
        setting.website[:locale] = I18n.default_locale.to_s if setting.website[:locale].blank?
        @locale = setting.website[:locale]
        setting.website[:light_theme] = attrs[:light_theme] if attrs[:light_theme]
        setting.website[:dark_theme] = attrs[:dark_theme] if attrs[:dark_theme]
        setting.website[:mode] = attrs[:mode] if attrs[:mode]
      end

      attrs = params[:racing_attributes] || {}
      if attrs.empty?
        setting.racing[:min_days_delay_from_last_race] ||= 0
        setting.racing[:min_days_delay_from_last_injury] ||= 0
        setting.racing[:min_days_rest_between_races] ||= 0
        setting.racing[:min_workouts_between_races] ||= 0
        setting.racing[:apply_minimums_for_future_races] ||= true
      else
        setting.racing[:min_energy_for_race_entry] = attrs[:min_energy_for_race_entry] if attrs[:min_energy_for_race_entry]
        setting.racing[:min_days_delay_from_last_race] = attrs[:min_days_delay_from_last_race] || 0
        setting.racing[:min_days_delay_from_last_injury] = attrs[:min_days_delay_from_last_injury] || 0
        setting.racing[:min_days_rest_between_races] = attrs[:min_days_rest_between_races] || 0
        setting.racing[:min_workouts_between_races] = attrs[:min_workouts_between_races] || 0
        setting.racing[:apply_minimums_for_future_races] = attrs[:apply_minimums_for_future_races] || true
      end

      setting.time_zone = params[:time_zone] if params[:time_zone]
    end

    def save_temporary_cookie(params:)
      locale = params.dig(:website_attributes, :locale) || I18n.default_locale.to_s
      cookies[:locale] = locale
    end

    def save_permanent_cookies(attrs, params)
      return unless params[:website_attributes]

      cookies.permanent[:locale] = locale
      if attrs[:mode]
        cookies.permanent[:mode] = attrs[:mode]
      elsif params[:mode]
        cookies.permanent[:mode] = params[:mode]
      end
      cookies.permanent[:dark_theme] = attrs[:dark_theme] if attrs[:dark_theme]
      cookies.permanent[:light_theme] = attrs[:light_theme] if attrs[:light_theme]
    end

    def locale_exists?
      I18n.available_locales.map(&:to_s).include?(locale)
    end
  end
end

