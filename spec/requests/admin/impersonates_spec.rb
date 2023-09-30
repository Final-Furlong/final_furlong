RSpec.describe "Impersonating users" do
  let(:user) { create(:user) }
  let(:current_user) { create(:admin) }

  before { sign_in(current_user) }

  describe "POST /create" do
    it "succeeds" do
      post admin_impersonate_path, params: { id: user.id }
      expect(response).to redirect_to root_path

      follow_redirect!
      expect(response.body).to include "Signed in as #{user.stable.name}"
    end

    context "when user is not admin" do
      let(:current_user) { create(:user) }

      it "fails" do
        expect do
          post admin_impersonate_path, params: { id: user.id }
        end.to raise_error ActionController::RoutingError, 'No route matches [POST] "/admin/impersonate"'
      end
    end
  end

  describe "DELETE /destroy" do
    it "succeeds" do
      post admin_impersonate_path, params: { id: user.id }
      expect(response).to redirect_to root_path
      delete admin_impersonate_path
      expect(response).to redirect_to root_path

      follow_redirect!
      expect(response.body).not_to include "Signed in as #{user.stable.name}"
    end
  end
end

