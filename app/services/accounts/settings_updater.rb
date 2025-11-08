module Accounts
  class SettingsUpdater
    attr_reader :locale, :cookies

    def call(params:, cookies: nil)
      locale = params[:locale] || I18n.default_locale.to_s
      user = Current.user
      @locale = locale
      @cookies = cookies
      result = Result.new(locale:)

      if user
        update_attrs = { locale: }
        update_attrs[:theme] = params[:theme] if params[:theme]
        update_attrs[:dark_theme] = params[:dark_theme] if params[:dark_theme]
        update_attrs[:dark_mode] = params[:dark_mode] == "1" if params[:dark_mode]

        setting = user.setting || user.build_setting
        if setting.update(update_attrs)
          save_permanent_cookies(update_attrs, params)
          result.updated = true
        else
          result.updated = false
          result.error = setting.errors.full_messages.to_sentence
        end
        result.setting = setting
      else
        save_temporary_cookie
        result.updated = true
      end
      result
    end

    class Result
      attr_reader :locale
      attr_accessor :updated, :setting, :error

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

    def save_temporary_cookie
      cookies[:locale] = locale
    end

    def save_permanent_cookies(attrs, params)
      cookies.permanent[:locale] = locale
      if attrs[:dark_mode]
        cookies.permanent[:dark_mode] = "true"
      elsif params[:dark_mode]
        cookies.delete :dark_mode
      end
      cookies.permanent[:dark_theme] = attrs[:dark_theme] if attrs[:dark_theme]
      cookies.permanent[:light_theme] = attrs[:theme] if attrs[:theme]
    end

    def locale_exists?
      I18n.available_locales.map(&:to_s).include?(locale)
    end
  end
end

