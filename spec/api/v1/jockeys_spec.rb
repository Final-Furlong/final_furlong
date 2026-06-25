describe Api::V1::Jockeys do
  describe "GET /api/v1/jockeys" do
    context "when jockey exists" do
      it "returns jockey info" do
        get("/api/v1/jockeys/#{jockey.id}", headers: { "Api-Key" => Rails.application.credentials.api.key! })

        expect(response).to have_http_status :ok
        expect(json_body).to eq ::Racing::JockeyBlueprint.render_as_json(jockey).symbolize_keys
      end
    end

    context "when jockey does not exist" do
      it "returns nil" do
        get("/api/v1/jockeys/1", headers: { "Api-Key" => Rails.application.credentials.api.key! })

        expect(response).to have_http_status :not_found
        expect(json_body).to eq({ error: "not_found", detail: "Couldn't find Racing::Jockey with 'id'=1" })
      end
    end

    it_behaves_like "an endpoint that requires an API key" do
      let(:method) { :get }
      let(:url) { "/api/v1/jockeys/1" }
    end
  end

  private

  def jockey
    @jockey ||= create(:jockey)
  end
end

