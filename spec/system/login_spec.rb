require "rails_helper"

RSpec.describe "Logging In", js: true do
  let(:user) { create(:user, password:) }
  let(:password) { "password1234" }

  context "when valid" do
    it "can login with username" do
      visit root_path
      expect(page).to have_link "Login", href: new_user_session_path

      click_on "Login"
      expect(page).to have_field "user[login]"

      fill_in "user[login]", with: user[:username]
      fill_in "user[password]", with: password
      click_on "Log in"

      expect(page).to have_text "Signed in successfully."
    end

    it "can login with email" do
      visit root_path
      expect(page).to have_link "Login", href: new_user_session_path

      click_on "Login"
      expect(page).to have_field "user[login]"

      fill_in "user[login]", with: user[:email]
      fill_in "user[password]", with: password
      click_on "Log in"

      expect(page).to have_text "Signed in successfully."
    end
  end

  context "when invalid" do
    it "shows errors" do
      visit new_user_session_path
      expect(page).to have_field "user[login]"

      fill_in "user[login]", with: user[:username]
      fill_in "user[password]", with: "super-seekrit"
      click_on "Log in"

      expect(page).to have_text "Invalid Login or password"
    end
  end
end
