describe Api::V1::Horses do
  describe "GET /api/v1/horses" do
    context "when horse exists" do
      it "returns horse info" do
        horse.update(sire: create(:stallion), dam: create(:broodmare))
        get("/api/v1/horses/#{horse.id}", headers: { "Api-Key" => Rails.application.credentials.api.key! })

        expect(response).to have_http_status :ok
        expect(json_body).to eq ::Horses::Racehorse::Blueprint.render_as_json(horse).symbolize_keys
      end

      context "when horse is created" do
        it "returns nil for sire/dam id" do
          horse.update(sire: nil, dam: nil)
          get("/api/v1/horses/#{horse.id}", headers: { "Api-Key" => Rails.application.credentials.api.key! })

          expect(response).to have_http_status :ok
          expect(json_body).to eq ::Horses::Racehorse::Blueprint.render_as_json(horse).symbolize_keys
        end
      end
    end

    context "when horse does not exist" do
      it "returns nil" do
        get("/api/v1/horses/1", headers: { "Api-Key" => Rails.application.credentials.api.key! })

        expect(response).to have_http_status :not_found
        expect(json_body).to eq({ error: "not_found", detail: "Couldn't find Horses::Horse::Racehorse with 'id'=1" })
      end
    end

    it_behaves_like "an endpoint that requires an API key" do
      let(:method) { :get }
      let(:url) { "/api/v1/horses/1" }
    end
  end

  private

  def horse
    @horse ||= create(:racehorse)
  end
end

