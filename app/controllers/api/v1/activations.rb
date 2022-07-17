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
          activation = Activation.find_by!(token: permitted_params[:token])
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
          activation = Activation.find_by!(token: permitted_params[:token])
          if activation.activated_at?
            error!({ error: "unexpected error", detail: "Already registered" }, 500)
          else
            matching = Stable.joins(user: :activation).exists?(
              name: permitted_params[:stable_name],
              user: { activations: { token: permitted_params[:token] } }
            )
            error!({ error: "invalid", detail: "Activation and stable do not match" }, 500) unless matching

            Activation.transaction do
              activation.user.active!
              activation.update!(activated_at: Time.current)
            end
            { url: rails_routes.new_user_password_path }
          end
        end
      end
    end
  end
end
