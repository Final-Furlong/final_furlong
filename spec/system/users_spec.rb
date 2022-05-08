# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
  context "when admin" do
    it "can create users" do
      visit users_path
      expect(page).to have_selector "h1", text: "Users"

      click_on "New user"
      expect(page).to have_selector "h1", text: "New user"

      attrs = attributes_for(:user)
      fill_in "user[username]", with: attrs[:username]
      fill_in "user[email]", with: attrs[:email]
      fill_in "user[name]", with: attrs[:name]
      click_on "Create user"

      expect(page).to have_selector "h1", text: "Users"
      expect(page).to have_text attrs[:name]
    end

    it "can view users" do
      user

      visit users_path
      click_link user.name

      expect(page).to have_selector "h1", text: user.name
    end

    it "can update a user" do
      user

      visit users_path
      expect(page).to have_selector "h1", text: "Users"

      click_on "Edit", match: :first
      expect(page).to have_selector "h1", text: "Edit user"

      fill_in "user[name]", with: "Updated name"
      click_on "Update user"

      expect(page).to have_selector "h1", text: "Users"
      assert_text "Updated name"
    end

    it "can destroy users" do
      user

      visit users_path
      expect(page).to have_text user.name

      click_on "Delete", match: :first
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
