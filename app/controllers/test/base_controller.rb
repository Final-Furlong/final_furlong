module Test
  class BaseController < ApplicationController
    respond_to :json
    rescue_from Exception, with: :show_errors

    private

    def show_errors(exception)
      error = {
        error: "#{exception.class}: #{exception}",
        backtrace: exception.backtrace.join("\n")
      }

      render(json: error, status: :bad_request) and return
    end
  end
end

