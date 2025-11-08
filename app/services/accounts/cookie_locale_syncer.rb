module Accounts
  class CookieLocaleSyncer
    attr_reader :cookies, :user

    def call(cookies: nil)
      return unless cookies

      @cookies = cookies

      if cookies[:locale] && Current.user
        sync_cookie_locale_to_user
      else
        clear_cookie_locale
      end
    end

    private

    def sync_cookie_locale_to_user
      return unless valid_locale?(cookies[:locale])

      Accounts::SettingsUpdater.new.call(params: { locale: cookies[:locale] }, cookies:)
    end

    def clear_cookie_locale
      cookies.delete :locale
    end

    def valid_locale?(locale)
      I18n.available_locales.map(&:to_s).include?(locale)
    end
  end
end

