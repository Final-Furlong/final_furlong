require "rails_helper"

RSpec.describe API::V1::Activations do
  describe "GET /api/v1/activations" do
    it "returns un-activated activations" do
      create(:activation, :activated)
      activation = create(:activation, :unactivated)

      get "/api/v1/activations"
      expect(response).to have_http_status :ok
      expect(json_body).to eq([serialize(model: activation)])
    end
  end

  describe "GET /api/v1/activations/:token" do
    context "when user matches unactivated token" do
      it "returns activation" do
        token = SecureRandom.uuid
        activation = create(:activation, :unactivated)
        activation.user.update!(confirmation_token: token)

        get "/api/v1/activations/#{token}"
        expect(response).to have_http_status :ok
        expect(json_body).to eq(serialize(model: activation))
      end
    end

    context "when user matches activated token" do
      it "returns error" do
        token = SecureRandom.uuid
        activation = create(:activation, :activated)
        activation.user.update!(confirmation_token: token)

        get "/api/v1/activations/#{token}"
        expect(response).to have_http_status :not_found
      end
    end

    context "when user does not match user" do
      it "returns error" do
        token = SecureRandom.uuid
        create(:user, confirmation_token: SecureRandom.uuid)

        get "/api/v1/activations/#{token}"
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe "POST /api/v1/activations/" do
    context "when stable matches unactivated activation" do
      it "returns URL to app" do
        token = SecureRandom.uuid
        activation = create(:activation, :unactivated, token:)
        stable = create(:stable, user: activation.user)

        post "/api/v1/activations/", params: { token:, stable_name: stable.name }
        expect(response).to have_http_status :created
        expect(json_body).to eq({ "url" => new_user_password_path })
      end

      it "updates activation to be activated" do
        token = SecureRandom.uuid
        activation = create(:activation, :unactivated, token:)
        stable = create(:stable, user: activation.user)

        expect do
          post "/api/v1/activations/", params: { token:, stable_name: stable.name }
        end.to change { activation.reload.activated_at }.from(nil)
      end
    end

    context "when stable matches activated activation" do
      it "returns error" do
        token = SecureRandom.uuid
        activation = create(:activation, :activated, token:)
        stable = create(:stable, user: activation.user)

        post "/api/v1/activations/", params: { token:, stable_name: stable.name }
        expect(response).to have_http_status :internal_server_error
        expect(json_body).to eq({ "error" => "unexpected error", "detail" => "Already registered" })
      end
    end

    context "when activation does not exist" do
      it "returns error" do
        token = SecureRandom.uuid

        post "/api/v1/activations/", params: { token:, stable_name: "foo" }
        expect(response).to have_http_status :not_found
      end
    end

    context "when stable does not match activation" do
      it "returns error" do
        token = SecureRandom.uuid
        create(:activation, :unactivated, token:)

        post "/api/v1/activations/", params: { token:, stable_name: "foo" }
        expect(response).to have_http_status :internal_server_error
        expect(json_body).to eq({ "error" => "invalid", "detail" => "Activation and stable do not match" })
      end
    end
  end
end
