class SettingsController < ApplicationController
  def create
    authorize %i[account settings]

    result = Accounts::SettingsUpdater.new.call(locale: update_params[:locale], cookies:)
    if result.updated?
      flash.now[:success] = t(".success.#{result.locale}")
    else
      flash.now[:alert] = result.error
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: helpers.render_turbo_stream_flash_messages }
      format.html { redirect_to root_path }
    end
  end

  private

  def update_params
    params.expect(settings: [:locale])
  end
end

