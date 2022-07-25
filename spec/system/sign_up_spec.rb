RSpec.describe "Signing Up", js: true do
  include Devise::Test::IntegrationHelpers

  context "when valid" do
    let(:attrs) { attributes_for(:user) }

    it "can join" do
      visit root_path
      within ".navbar" do
        expect(page).to have_link t("layouts.nav.join"), href: new_user_registration_path

        click_on t("layouts.nav.join")
      end

      expect(page).to have_field "user[username]"

      within ".simple_form" do
        fill_in "user[username]", with: attrs[:username]
        fill_in "user[email]", with: attrs[:email]
        fill_in "user[name]", with: attrs[:name]
        fill_in "user[password]", with: attrs[:password]
        fill_in "user[password_confirmation]", with: attrs[:password]
        click_on t("devise.registrations.new.sign_up")
      end

      expect(page).to have_text "A message with a confirmation link " \
                                "has been sent to your email address. " \
                                "Please follow the link to activate your account."
    end
  end

  context "when invalid" do
    let(:attrs) { attributes_for(:user).merge(password: "123") }

    it "shows errors" do
      visit root_path
      within ".navbar" do
        expect(page).to have_link t("layouts.nav.join"), href: new_user_registration_path

        click_on t("layouts.nav.join")
      end
      expect(page).to have_field "user[username]"

      within ".simple_form" do
        fill_in "user[username]", with: attrs[:username]
        fill_in "user[email]", with: attrs[:email]
        fill_in "user[name]", with: attrs[:name]
        fill_in "user[password]", with: attrs[:password]
        fill_in "user[password_confirmation]", with: attrs[:password]
        click_on t("devise.registrations.new.sign_up")
      end

      expect(page).to have_text "Password is too short"
    end
  end
end
