require "rails_helper"

RSpec.describe Api::V1::Activations do
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
      it "returns ok status" do
        user = create(:user, :pending, :without_stable)
        token = Digest::MD5.hexdigest user.email
        create(:activation, :unactivated, user:, token:)

        get "/api/v1/activations/#{token}"
        expect(response).to have_http_status :ok
        expect(json_body).to eq("status" => "ok")
      end
    end

    context "when user matches activated token" do
      it "returns error" do
        user = create(:user, :pending, :without_stable)
        token = Digest::MD5.hexdigest user.email
        create(:activation, :activated, user:)

        get "/api/v1/activations/#{token}"
        expect(response).to have_http_status :not_found
      end
    end

    context "when token does not match user" do
      it "returns error" do
        token = SecureRandom.uuid

        get "/api/v1/activations/#{token}"
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe "POST /api/v1/activations/" do
    context "when stable matches unactivated activation" do
      it "returns URL to app" do
        user = create(:user, :pending, :without_stable)
        token = Digest::MD5.hexdigest user.email
        create(:activation, :unactivated, token:, user:)
        stable = create(:stable, user:)

        post "/api/v1/activations/", params: { token:, stable_name: stable.name }
        expect(response).to have_http_status :created
        expect(json_body).to eq({ "url" => new_user_password_path })
      end

      it "updates activation to be activated" do
        user = create(:user, :pending, :without_stable)
        token = Digest::MD5.hexdigest user.email
        activation = create(:activation, :unactivated, token:, user:)
        stable = create(:stable, user:)

        expect do
          post "/api/v1/activations/", params: { token:, stable_name: stable.name }
        end.to change { activation.reload.activated_at }.from(nil)
      end

      it "updates user to be active" do
        user = create(:user, :pending, :without_stable)
        token = Digest::MD5.hexdigest user.email
        create(:activation, :unactivated, token:, user:)
        stable = create(:stable, user:)

        expect do
          post "/api/v1/activations/", params: { token:, stable_name: stable.name }
        end.to change { user.reload.status }.from("pending").to("active")
      end
    end

    context "when stable matches activated activation" do
      it "returns error" do
        user = create(:user, :pending, :without_stable)
        token = Digest::MD5.hexdigest user.email
        create(:activation, :activated, token:, user:)
        stable = create(:stable, user:)

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
