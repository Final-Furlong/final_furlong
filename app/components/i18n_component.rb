class I18nComponent < ApplicationComponent
  with_collection_parameter :locale

  def initialize(locale:)
    @locale = locale[:locale]
    @current_locale = locale[:current].to_s
    super
  end

  private

  def locale_set_icon
    content_tag(:span)
  end

  def current_locale?
    @current_locale == @locale
  end

  def locale_language
    "English"
  end

  def icon_classes
    case @locale
    when "en-GB"
      "fi fi-gb"
    when "en"
      "fi fi-us"
    end
  end
end
