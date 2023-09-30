RSpec.describe "Current Stable > Horses" do
  describe "GET /index" do
    it "succeeds" do
      user = create(:user)
      stable = user.stable
      horse = create(:horse, owner: stable)
      sign_in(user)

      get stable_horses_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include horse.name
    end

    it_behaves_like "an endpoint that requires authentication" do
      let(:trigger_page) { get stable_horses_path }
    end
  end
end

