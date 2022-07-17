RSpec.describe "Users", js: true do
  include Devise::Test::IntegrationHelpers

  context "when admin" do
    let(:admin) { create(:admin) }

    before { sign_in admin }

    it "can create users" do
      visit users_path
      expect(page).to have_selector "h1", text: I18n.t("users.index.title")

      click_on I18n.t("users.index.new_user")
      expect(page).to have_field "user[username]"

      attrs = attributes_for(:user)
      fill_in "user[username]", with: attrs[:username]
      fill_in "user[email]", with: attrs[:email]
      fill_in "user[name]", with: attrs[:name]
      fill_in "user[password]", with: "Password123!"
      fill_in "user[password_confirmation]", with: "Password123!"
      fill_in "user[stable_name]", with: "Test Stable"
      click_on I18n.t("helpers.submit.user.create")

      expect(page).to have_selector "h1", text: I18n.t("users.index.title")
      # expect(page).to have_text attrs[:name]
    end

    it "errors create on password" do
      visit users_path
      expect(page).to have_selector "h1", text: I18n.t("users.index.title")

      click_on I18n.t("users.index.new_user")
      expect(page).to have_field "user[username]"

      attrs = attributes_for(:user)
      fill_in "user[username]", with: attrs[:username]
      fill_in "user[email]", with: attrs[:email]
      fill_in "user[name]", with: attrs[:name]
      fill_in "user[password]", with: "abc"
      fill_in "user[password_confirmation]", with: "abc"
      fill_in "user[stable_name]", with: "Test Stable"
      click_on I18n.t("helpers.submit.user.create")

      expect(page).to have_text "Password is too short"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      click_on I18n.t("helpers.submit.user.create")
      expect(page).to have_text I18n.t("activemodel.errors.messages.weak")
    end

    it "can view users" do
      user
      user2 = create(:user)

      visit users_path
      expect(page).to have_text I18n.t("users.index.title")
      expect(page).to have_selector "turbo-frame[id='user_#{user.id}']"
      expect(page).to have_selector "turbo-frame[id='user_#{user2.id}']"

      click_link user.name
      expect(page).to have_selector "h1", text: user.name
    end

    it "can update a user" do
      user

      visit users_path
      expect(page).to have_selector "h1", text: I18n.t("users.index.title")

      click_on("user-edit-#{user.id}")
      expect(page).to have_field "user[name]", with: user.name
      fill_in "user[name]", with: "Updated name"
      click_on I18n.t("helpers.submit.user.update")
      expect(page).to have_text "Updated name"

      expect(page).to have_selector "h1", text: "Users"
      expect(user.reload.name).to eq "Updated name"
      visit user_path(user.id)
      expect(page).to have_text "Updated name"
    end

    it "can destroy users" do
      user

      visit users_path
      expect(page).to have_text user.name

      click_on("user-delete-#{user.id}")
      assert_no_text user.name
    end
  end

  def user
    @user ||= create(:user)
  end
end
