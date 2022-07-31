class I18nComponent < ApplicationComponent
  def initialize(locale:)
    @locale = locale.to_s
    super
  end

  private

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
