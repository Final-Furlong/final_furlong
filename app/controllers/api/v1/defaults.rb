module Api
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json,
          Grape::Formatter::ActiveModelSerializers

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def logger
            Rails.logger
          end

          def rails_routes
            Rails.application.routes.default_url_options[:host] = ENV.fetch("RAILS_APP_URL", "http://localhost:3000")
            Rails.application.routes.url_helpers
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error!(e, 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error!(e, 422)
        end
      end
    end
  end
end

