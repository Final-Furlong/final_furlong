class SettingsController < ApplicationController
  def new
    authorize %i[account settings]
    @settings = Current.user.setting || Current.user.build_setting
    @locales = locale_options
    @light_themes = light_theme_options
    @dark_themes = dark_theme_options
  end

  def create
    authorize %i[account settings]

    result = Accounts::SettingsUpdater.new.call(params: update_params, cookies:)
    if result.updated?
      flash.now[:success] = Current.user ? t(".success_full") : t(".success.#{result.locale}")
    else
      flash.now[:alert] = result.error
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_flash_messages }
      format.html { redirect_to root_path }
    end
  end

  private

  def locale_options
    I18n.available_locales.map do |locale|
      [locale.to_s, I18n.t("i18n.#{locale.to_s.tr("-", "_").downcase}_language")]
    end
  end

  def light_theme_options
    %w[light cupcake bumblebee emerald corporate retro cyberpunk valentine garden
      lofi pastel fantasy wireframe autumn acid lemonade winter nord caramellatte
      silk].map do |theme|
      [theme, I18n.t("daisy_ui.#{theme}")]
    end.sort
  end

  def dark_theme_options
    %w[dark synthwave halloween forest aqua black luxury dracula business acid
      night coffee dim sunset abyss].map do |theme|
      [theme, I18n.t("daisy_ui.#{theme}")]
    end.sort
  end

  def update_params
    params.expect(settings: [:locale, :theme, :dark_theme, :dark_mode])
  end
end

