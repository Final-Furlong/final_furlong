RSpec.shared_examples "an endpoint that requires authentication" do
  context "when user is not logged in" do
    it "requires login" do
      trigger_page

      expect(response).to redirect_to new_user_session_path
    end
  end
end

RSpec.shared_examples "an endpoint that requires authentication with custom unauthorized path" do
  context "when user is not logged in" do
    it "requires login" do
      trigger_page

      expect(response).to redirect_to unauthorized_path
    end
  end
end

