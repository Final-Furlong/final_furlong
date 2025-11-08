module Accounts
  class CookieLocaleSyncer
    attr_reader :cookies, :user

    def call(cookies: nil)
      @user = Current.user
      return unless cookies

      @cookies = cookies

      if cookies[:locale] && user
        sync_cookie_locale_to_user
      else
        clear_cookie_locale
      end
    end

    private

    def sync_cookie_locale_to_user
      return unless valid_locale?(cookies[:locale])

      Accounts::SettingsUpdater.new.call(locale: cookies[:locale], cookies:)
    end

    def clear_cookie_locale
      cookies.delete :locale
    end

    def valid_locale?(locale)
      I18n.available_locales.map(&:to_s).include?(locale)
    end
  end
end

