RSpec.describe "Login Spec" do
  context "when SSO works" do
    it "allows login with email" do
      admin

      visit root_path
      within("#top_nav") do
        click_on t("layouts.nav.login")
      end
      expect(page).to have_current_path current_stable_path
      within(".badge") do
        expect(page).to have_text t("view_components.users.online_badge.online")
      end
      expect(page.driver.request.cookies.keys).to include "_final_furlong_session"
    end
  end

  private

  def admin
    @admin ||= create(:admin, email: "admin@example.com")
  end
end
