class SettingsController < ApplicationController
  def new
    authorize %i[account settings]
    @settings = Current.user.setting || Current.user.build_setting
    @locales = locale_options
    @light_themes = light_theme_options
    @dark_themes = dark_theme_options
    @modes = mode_options
    @current_tab = (params[:tab] || "security").to_s
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
    Config::Website.light_themes.map do |theme|
      [theme, I18n.t("daisy_ui.#{theme}")]
    end.sort
  end

  def dark_theme_options
    Config::Website.dark_themes.map do |theme|
      [theme, I18n.t("daisy_ui.#{theme}")]
    end.sort
  end

  def mode_options
    Config::Website.modes.map do |mode|
      [mode, I18n.t("activerecord.attributes.setting.mode.#{mode}")]
    end.sort
  end

  def update_params
    params.expect(settings: [:time_zone,
      racing_attributes: [:min_energy_for_race_entry, :min_days_delay_from_last_race,
        :min_days_delay_from_last_injury, :min_days_rest_between_races,
        :min_workouts_between_races, :apply_minimums_for_future_races],
      website_attributes: [:light_theme, :dark_theme, :mode, :locale]])
  end
end

