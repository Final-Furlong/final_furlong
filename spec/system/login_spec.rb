RSpec.describe "Logging In", js: true do
  let(:user) { create(:user, password:) }
  let(:password) { "password1234" }

  context "when valid" do
    it "can login with username" do
      visit root_path
      within ".navbar" do
        expect(page).to have_link t("layouts.nav.login"), href: new_user_session_path

        click_on t("layouts.nav.login")
      end

      expect(page).to have_field "user[login]"
      within ".simple_form" do
        fill_in "user[login]", with: user[:username]
        fill_in "user[password]", with: password
        click_on t("devise.sessions.new.sign_in")
      end

      expect(page).to have_text t("devise.sessions.signed_in")
    end

    it "can login with email" do
      visit root_path
      within ".navbar" do
        expect(page).to have_link t("layouts.nav.login"), href: new_user_session_path

        click_on t("layouts.nav.login")
      end

      expect(page).to have_field "user[login]"

      within ".simple_form" do
        fill_in "user[login]", with: user[:email]
        fill_in "user[password]", with: password
        click_on t("devise.sessions.new.sign_in")
      end

      expect(page).to have_text t("devise.sessions.signed_in")
    end
  end

  context "when invalid" do
    it "shows errors" do
      visit new_user_session_path
      within ".simple_form" do
        expect(page).to have_field "user[login]"

        fill_in "user[login]", with: user[:username]
        fill_in "user[password]", with: "super-seekrit"
        click_on t("devise.sessions.new.sign_in")
      end

      expect(page).to have_text t("devise.failure.invalid", authentication_keys: "Login")
    end
  end
end
