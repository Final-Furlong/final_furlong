module Users
  class SyncLocale < BaseInteraction
    object :user, class: Account::User, default: nil
    object :cookies, class: ActionDispatch::Cookies::CookieJar

    string :locale, default: I18n.default_locale.to_s

    def execute
      if user&.locale
        sync_user_locale_to_cookies
      elsif cookies[:locale] && user
        sync_cookie_locale_to_user
      else
        clear_cookie_locale
      end
    end

    private

      def sync_user_locale_to_cookies
        cookies.permanent[:locale] = valid_locale?(user.locale) ? user.locale.to_s : locale
      end

      def sync_cookie_locale_to_user
        return unless valid_locale?(cookies[:locale])

        setting = user.setting || user.build_setting
        setting.update!(locale: cookies[:locale].to_s)
      end

      def clear_cookie_locale
        return if valid_locale?(cookies[:locale])

        cookies.delete :locale
      end

      def valid_locale?(locale)
        I18n.available_locales.map(&:to_s).include?(locale)
      end
  end
end

