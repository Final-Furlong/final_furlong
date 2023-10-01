module Api
  module V1
    class Activations < Grape::API
      include Api::V1::Defaults

      helpers do
        def repo
          Account::ActivationsRepository.new(model: Account::Activation)
        end

        def query
          Account::ActivationQuery.new
        end
      end

      resource :activations do
        desc "Return all un-activated activation tokens"
        get do
          Account::ActivationQuery.new.unactivated
        end

        desc "Return status of the activation"
        params do
          requires :token, type: String, desc: "Unique token of the user"
        end
        get ":token" do
          activation = repo.find_by!(token: permitted_params[:token])
          error!({ error: "invalid", detail: "Already activated" }) if activation.activated_at
          error!({ error: "invalid", detail: "Already active" }) if activation.user.active?

          { status: :ok }
        end

        desc "Activate a user by token"
        params do
          requires :token, type: String, desc: "Unique token of the activation"
          requires :stable_name, type: String, desc: "Stable name for the user"
        end
        post "/" do
          activation = repo.find_by!(token: permitted_params[:token])
          if activation.activated_at?
            error!({ error: "unexpected error", detail: "Already registered" }, 500)
          else
            matching = query.exists_with_token?(
              stable_name: permitted_params[:stable_name], token: permitted_params[:token]
            )
            error!({ error: "invalid", detail: "Activation and stable do not match" }, 500) unless matching

            repo.activate!(activation)
            { url: rails_routes.new_user_password_path }
          end
        end
      end
    end
  end
end

