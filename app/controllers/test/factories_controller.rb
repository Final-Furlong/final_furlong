require "factory_bot_rails"
require "faker"

module Test
  class FactoriesController < BaseController
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

    private

      def strategy
        params[:strategy] || :create
      end

      def traits
        params[:traits].map { |_key, trait| trait.to_sym } if params[:traits].present?
      end

      def factory
        params[:factory].to_sym
      end

      def attributes
        params.except(:factory, :strategy, :traits, :controller, :action, :number).symbolize_keys
      end
  end
end

