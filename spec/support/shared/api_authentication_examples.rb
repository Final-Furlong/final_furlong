RSpec.shared_examples "an endpoint that requires an API key" do
  context "when API Key is missing" do
    it "returns error" do
      params ||= {}
      send(method.to_sym, url, params:, headers: {})

      expect(response).to have_http_status :unauthorized
      expect(json_body).to eq({ error: "invalid", detail: "No API key provided" })
    end
  end

  context "when API key is wrong" do
    it "returns error" do
      params ||= {}
      send(method.to_sym, url, params:, headers: { "Api-Key" => "foo" })

      expect(response).to have_http_status :unauthorized
      expect(json_body).to eq({ error: "invalid", detail: "Invalid API key" })
    end
  end
end

