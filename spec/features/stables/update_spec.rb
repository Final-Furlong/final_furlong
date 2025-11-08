RSpec.describe "Update Stable Description" do
  it "cannot update as visitor" do
    visit edit_current_stable_path

    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end

  context "when user is signed in" do
    before { sign_in(user) }

    it "allows update to description" do
      visit stable_path(stable)
      within("#breadcrumb-actions") do
        click_on t("common.edit")
      end
      updated_description = "Test description"
      expect(page).to have_current_path edit_current_stable_path, ignore_query: true
      fill_in "stable[description]", with: updated_description
      click_on t("common.actions.cancel")
      expect(page).to have_current_path current_stable_path, ignore_query: true
      visit edit_current_stable_path
      fill_in "stable[description]", with: updated_description
      click_on t("stables.form.update")
      expect(page).to have_current_path current_stable_path, ignore_query: true
      expect(page).to have_text updated_description
    end

    it "does not allow a description that is too long" do
      updated_description = "x" * 1001
      visit edit_current_stable_path
      fill_in "stable[description]", with: updated_description
      click_on t("stables.form.update")
      expect(page).to have_current_path current_stable_path, ignore_query: true
      within(".alert") do
        expect(page).to have_text "Description is too long"
      end
      expect(page).not_to have_text updated_description
    end

    it_behaves_like "a page that is accessible" do
      let(:path_to_visit) { current_stable_path }
    end
  end

  private

  def user
    @user ||= create(:user)
  end

  def stable
    @stable ||= user.stable
  end
end

