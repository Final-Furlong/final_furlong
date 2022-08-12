class I18nComponent < VariantComponent
  def initialize(locale:, version: :navbar, variants: :desktop)
    @locale = locale.to_s
    super(version:, variants:)
  end

  private

    def render?
      visible_on_desktop? || visible_on_tablet? || visible_on_phone?
    end

    def american_locale?
      @locale == "en"
    end

    def british_locale?
      @locale == "en-GB"
    end

    def locale_language
      "English"
    end

    def icon_classes
      british_locale? ? "fi fi-gb" : "fi fi-us"
    end
end
