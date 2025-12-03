module Account
  module Settings
    class Website
      include StoreModel::Model

      MODES = %w[light dark].freeze
      LIGHT_THEMES = %w[light cupcake bumblebee emerald corporate retro cyberpunk valentine garden
        lofi pastel fantasy wireframe autumn acid lemonade winter nord caramellatte
        silk].freeze
      DARK_THEMES = %w[dark synthwave halloween forest aqua black luxury dracula business acid
        night coffee dim sunset abyss].freeze

      attribute :light_theme, :string
      attribute :dark_theme, :string
      attribute :mode, :string
      attribute :locale, :string

      validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s), message: :invalid }, allow_nil: true
      validates :mode, inclusion: { in: MODES }, allow_nil: true
      validates :light_theme, inclusion: { in: LIGHT_THEMES }, allow_nil: true
      validates :dark_theme, inclusion: { in: DARK_THEMES }, allow_nil: true
    end
  end
end

