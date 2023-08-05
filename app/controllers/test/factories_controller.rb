if Rails.env.test?
  require "factory_bot_rails"
  require "faker"
end

module Test
  class FactoriesController < BaseController
    before_action :permit_all_params

    def show
      result = model_name.find_by(search_params)

      render json: result.to_json, status: :ok
    end

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
      instance = model_name.find(params[:id])
      instance.update!(attributes)

      render json: instance.reload.to_json, status: :ok
    end

    private

      def search_params
        case model_name
        when Account::Stable
          stable_params
        when Account::User
          user_params
        end
      end

      def user_params
        user_keys = %i[id username email]
        params.select { |key, value| user_keys.include?(key.to_sym) && value.present? }
      end

      def stable_params
        stable_keys = %i[id user_id]
        attrs = params.select { |key, value| stable_keys.include?(key.to_sym) && value.present? }
        if params[:email]
          user = Accounts::User.find_by(email: params[:email])
          attrs[:user_id] = user.id
        end
        attrs
      end

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

