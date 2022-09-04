require "factory_bot_rails"
require "faker"

module Test
  class FactoriesController < BaseController
    before_action :permit_all_params

    def create
      result = case strategy
               when :create
                 FactoryBot.create(factory, *traits, attributes)
               when :attributes
                 FactoryBot.attributes_for(factory, *traits, attributes)
               else
                 raise "Unknown strategy: #{strategy}"
               end
      render json: result.to_json, status: :created
    end

    def update
      result = model_name.find(params[:id]).update!(attributes)

      render json: result.to_json, status: :created
    end

    private

      def strategy
        params[:strategy] || :create
      end

      def traits
        return [] if params[:traits].blank?

        params[:traits].map { |_key, trait| trait.to_sym }
      end

      def factory
        raise StandardError, "factory name is required" unless params[:factory]

        params[:factory].to_sym
      end

      def model_name
        raise StandardError, "model is required" unless params[:model]

        params[:model].classify.constantize
      end

      def attributes
        params.to_h.symbolize_keys.except(:factory, :strategy, :traits, :controller, :action, :number, :model, :id)
      end

      def permit_all_params
        ActionController::Parameters.permit_all_parameters = true
      end
  end
end

