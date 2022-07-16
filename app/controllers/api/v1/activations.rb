module API
  module V1
    class Activations < Grape::API
      include API::V1::Defaults

      resource :activations do
        desc "Return all un-activated activation tokens"
        get do
          Activation.activated.invert_where
        end

        desc "Return a user token"
        params do
          requires :token, type: String, desc: "Unique token of the user"
        end
        get ":token" do
          user = User.find_by!(confirmation_token: permitted_params[:token])
          Activation.activated.invert_where.find_by!(user:)
        end

        desc "Activate a user by token"
        params do
          requires :token, type: String, desc: "Unique token of the activation"
          requires :stable_name, type: String, desc: "Stable name for the user"
        end
        post "/" do
          activation = Activation.find_by!(token: permitted_params[:token])
          if activation.activated_at?
            error!({ error: "unexpected error", detail: "Already registered" }, 500)
          else
            matching = Stable.joins(user: :activation).exists?(
              name: permitted_params[:stable_name],
              user: { activations: { token: permitted_params[:token] } }
            )
            error!({ error: "invalid", detail: "Activation and stable do not match" }, 500) unless matching

            activation.update!(activated_at: Time.current)
            { url: rails_routes.new_user_password_path }
          end
        end
      end
    end
  end
end
