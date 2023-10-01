RSpec.describe "Users" do
  describe "GET /index" do
    it "succeeds" do
      admin = create(:admin)
      sign_in(admin)

      get users_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include admin.name
    end

    it_behaves_like "an endpoint that requires authentication" do
      let(:trigger_page) { get users_path }
    end
  end
end

