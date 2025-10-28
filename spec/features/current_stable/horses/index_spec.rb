RSpec.describe "Viewing Own Horses" do
  context "when horses exist" do
    it "shows horses owned by the stable" do
      stable = create(:stable)
      user = stable.user
      horse1 = create(:horse, owner: stable)
      horse2 = create(:horse, owner: stable)
      horse3 = create(:horse, owner: create(:stable))

      sign_in(user)
      visit stable_horses_path
      expect(page).to have_link t("common.actions.view"), href: horse_path(horse1)
      expect(page).to have_link t("common.actions.view"), href: horse_path(horse2)
      expect(page).not_to have_link t("common.actions.view"), href: horse_path(horse3)
    end
  end

  context "when horses do not exist" do
    it "does not show horses" do
      stable = create(:stable)
      user = stable.user

      sign_in(user)
      visit stable_horses_path
      expect(page).to have_text t("current_stable.horses.index.title")
    end
  end
end

