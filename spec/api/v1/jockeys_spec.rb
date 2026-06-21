RSpec.describe Api::V1::Jockeys do
  describe "GET /api/v1/jockeys" do
    context "when jockey exists" do
      it "returns jockey info" do
        get("/api/v1/jockeys/#{jockey.id}", headers: { "Api-Key" => Rails.application.credentials.dig(:api, :key) })

        expect(response).to have_http_status :ok
        expect(json_body).to eq ActiveModelSerializers::SerializableResource.new(jockey, adapter: :json).as_json.first.last.symbolize_keys
      end
    end

    context "when jockey does not exist" do
      it "returns nil" do
        get("/api/v1/jockeys/1", headers: { "Api-Key" => Rails.application.credentials.dig(:api, :key) })

        expect(response).to have_http_status :not_found
        expect(json_body).to eq({ error: "Couldn't find Racing::Jockey with 'id'=1" })
      end
    end

    context "when API Key is missing" do
      it "returns error" do
        get("/api/v1/jockeys/1", headers: {})

        expect(response).to have_http_status :unauthorized
        expect(json_body).to eq({ error: "No API key provided" })
      end
    end

    context "when API key is wrong" do
      it "returns error" do
        get("/api/v1/jockeys/1", headers: { "Api-Key" => "foo" })

        expect(response).to have_http_status :unauthorized
        expect(json_body).to eq({ error: "Invalid API key" })
      end
    end
  end

  private

  def jockey
    @jockey ||= create(:jockey)
  end
end

