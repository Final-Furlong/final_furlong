module Account
  module Settings
    class Website
      include StoreModel::Model

      attribute :light_theme, :string
      attribute :dark_theme, :string
      attribute :mode, :string
      attribute :locale, :string

      validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s), message: :invalid }, allow_nil: true
      validates :mode, inclusion: { in: Config::Website.modes }, allow_nil: true
      validates :light_theme, inclusion: { in: Config::Website.light_themes }, allow_nil: true
      validates :dark_theme, inclusion: { in: Config::Website.dark_themes }, allow_nil: true
    end
  end
end

