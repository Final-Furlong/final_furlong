module Test
  class SessionsController < BaseController
    skip_before_action :update_stable_online

    def create
      sign_in(user, scope: :user)
      stable = user.stable

      render json: { user:, stable: }.to_json, status: :created
    end

    def destroy
      return unless current_user

      sign_out

      render json: :ok, status: :deleted
    end

    private

      def user
        return Account::User.find(params[:id]) if params[:id]

        Account::User.find_by!(username: params[:username])
      end
  end
end

