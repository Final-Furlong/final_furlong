require "openssl"

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

        rescue_from Grape::Exceptions::ValidationErrors do |e|
          error!({ messages: e.full_messages }, 400)
        end

        before do
          validate_api_key
        end

        helpers do
          def validate_api_key
            api_key = headers["Api-Key"]
            expected_key = Rails.application.credentials.dig(:api, :key)

            error!("Missing configured api key", 500) unless expected_key
            error!("No API key provided", 401) unless api_key

            unless secure_compare(api_key, expected_key)
              error!("Invalid API key", 401)
            end
          end

          def secure_compare(a, b)
            return false unless a.bytesize == b.bytesize

            OpenSSL.secure_compare(a, b)
          end

          def permitted_params
            @permitted_params ||= declared(params, include_missing: false, evaluate_given: true)
          end

          delegate :logger, to: :Rails

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

