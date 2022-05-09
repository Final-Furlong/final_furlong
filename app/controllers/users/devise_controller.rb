class Users::DeviseController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      render_success
    rescue ActionView::MissingTemplate => e
      raise e if get?

      if can_render_error?
        render_regular
      else
        redirect
      end
    end

    private

    def render_success
      controller.render(options.merge(formats: :html))
    end

    def can_render_error?
      has_errors? && default_action
    end

    def render_regular
      render rendering_options.merge(formats: :html, status: :unprocessable_entity)
    end

    def redirect
      redirect_to navigation_location
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end
