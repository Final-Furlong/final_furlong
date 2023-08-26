module Users
  class UpdateLocale < BaseInteraction
    object :user, class: Account::User, default: nil

    string :locale, default: I18n.default_locale.to_s

    def execute
      validate_locale
      store_locale_setting
      locale
    end

    private

    def validate_locale
      errors.add(:locale, :invalid) unless locale_exists?
    end

    def locale_exists?
      I18n.available_locales.map(&:to_s).include?(locale)
    end

    def store_locale_setting
      return unless user

      setting = user.setting || user.build_setting
      setting.update!(locale:)
    end
  end
end

