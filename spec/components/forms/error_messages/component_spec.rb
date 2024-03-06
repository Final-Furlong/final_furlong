RSpec.describe Forms::ErrorMessages::Component, type: :component do
  subject(:component) { described_class.new(object: user) }

  let(:user) { build(:user) }

  before { user.valid? }

  context "when object has no errors" do
    it "displays nothing" do
      render_inline(component)

      expect(page).to have_no_css(".notification")
    end
  end

  context "when object has errors" do
    let(:user) { build(:user, username: "aaa", email: "ab") }

    it "displays all errors" do
      render_inline(component)

      within ".notifications" do
        expect(page).to have_text "Email is invalid and username is too short (minimmum is 4 characters)"
      end
    end
  end
end

