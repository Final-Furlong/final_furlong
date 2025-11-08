module Accounts
  class SettingsUpdater
    attr_reader :locale, :cookies

    def call(locale: I18n.default_locale.to_s, cookies: nil)
      user = Current.user
      @locale = locale
      @cookies = cookies
      result = Result.new(locale:)

      setting = user.setting || user.build_setting
      if setting.update(locale:)
        save_locale_to_cookies
        result.updated = true
      else
        result.updated = false
        result.error = setting.errors.full_messages.to_sentence
      end
      result.setting = setting
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

    def save_locale_to_cookies
      cookies.permanent[:locale] = locale
    end

    def locale_exists?
      I18n.available_locales.map(&:to_s).include?(locale)
    end
  end
end

