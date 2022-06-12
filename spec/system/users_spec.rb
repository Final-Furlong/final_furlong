# typed: false
RSpec.describe "Users", js: true do
  include Devise::Test::IntegrationHelpers

  context "when admin" do
    let(:admin) { create(:admin) }

    before { sign_in admin }

    it "can create users" do
      visit users_path
      expect(page).to have_selector "h1", text: "Users"

      click_on "New user"
      expect(page).to have_field "user[username]"

      attrs = attributes_for(:user)
      fill_in "user[username]", with: attrs[:username]
      fill_in "user[email]", with: attrs[:email]
      fill_in "user[name]", with: attrs[:name]
      fill_in "user[password]", with: "abc"
      fill_in "user[password_confirmation]", with: "abc"
      click_on "Create user"

      expect(page).to have_text "Password is too short"
      fill_in "user[password]", with: attrs[:password]
      fill_in "user[password_confirmation]", with: attrs[:password]
      click_on "Create user"

      expect(page).to have_selector "h1", text: "Users"
      expect(page).to have_text attrs[:name]
    end

    it "can view users" do
      user
      user2 = create(:user)

      visit users_path
      expect(page).to have_text "Users"
      expect(page).to have_selector "turbo-frame[id='user_#{user.id}']"
      expect(page).to have_selector "turbo-frame[id='user_#{user2.id}']"

      click_link user.name
      expect(page).to have_selector "h1", text: user.name
    end

    it "can update a user" do
      user

      visit users_path
      expect(page).to have_selector "h1", text: "Users"

      click_on("user-edit-#{user.id}")
      expect(page).to have_field "user[name]", with: user.name
      fill_in "user[username]", with: " "
      click_on "Update user"

      expect(page).to have_text "Username can't be blank"
      fill_in "user[username]", with: "Updated name"
      click_on "Update user"

      expect(page).to have_selector "h1", text: "Users"
      visit user_path(user.reload)
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

  context "when a regular user" do
    it "cannot create users"
    it "can view users"
    it "can update self"
    it "cannot update others"
    it "cannot destroy self"
    it "cannot destroy others"
  end

  def user
    @user ||= create(:user)
  end
end
