class GraphqlController < ApplicationController
  # before_action :authenticate_jwt_request!
  skip_after_action :verify_authorized

  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  # @route POST /graphql (graphql)
  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    result = FinalFurlongSchema.execute(query, variables:, context:, operation_name:)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

    def context
      {
        current_user:
      }
    end

    # Handle variables in form data, JSON body, or a blank value
    # rubocop:disable Metrics/MethodLength
    def prepare_variables(variables_param)
      case variables_param
      when String
        variables_from_json(variables_param)
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{variables_param}"
      end
    end
    # rubocop:enable Metrics/MethodLength

    def variables_from_json(variables)
      if variables
        JSON.parse(variables) || {}
      else
        {}
      end
    end

    def handle_error_in_development(error)
      logger.error error.message
      logger.error error.backtrace.join("\n")

      render json: { errors: [{ message: error.message, backtrace: error.backtrace }], data: {} },
             status: :internal_server_error
    end
end

