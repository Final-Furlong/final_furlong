class SettingsController < ApplicationController
  def create
    authorize %i[account settings]

    if outcome.valid?
      locale = save_locale_cookie(outcome)

      flash[:success] = t(".success.#{locale}")
    else
      flash[:alert] = errors
    end
    redirect_to root_path
  end

  private

  def errors
    outcome.errors.full_messages.to_sentence
  end

  def outcome
    @outcome ||= Users::UpdateLocale.run(update_params)
  end

  def update_params
    params.expect(settings: [:locale]).merge(user: current_user)
  end

  def save_locale_cookie(outcome)
    locale = outcome.result
    cookies.permanent[:locale] = locale
    locale
  end
end

