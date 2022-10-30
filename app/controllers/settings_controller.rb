class SettingsController < ApplicationController
  skip_after_action :verify_policy_scoped

  # @route PUT /settings (settings)
  # @route PATCH /settings (settings)
  def update
    authorize :settings

    # rubocop:disable Rails/ActionControllerFlashBeforeRender
    if outcome.valid?
      locale = save_locale_cookie(outcome)

      flash[:notice] = t(".success.#{locale}")
    else
      flash[:alert] = errors
    end
    redirect_to root_path
    # rubocop:enable Rails/ActionControllerFlashBeforeRender
  end

  private

    def errors
      outcome.errors.full_messages.to_sentence
    end

    def outcome
      @outcome ||= Users::UpdateLocale.run(update_params)
    end

    def update_params
      params.merge(user: current_user)
    end

    def save_locale_cookie(outcome)
      locale = outcome.result
      cookies.permanent[:locale] = locale
      locale
    end
end

