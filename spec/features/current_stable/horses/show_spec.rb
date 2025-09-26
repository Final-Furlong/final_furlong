RSpec.describe "Viewing Own Horse" do
  context "when horse exist" do
    it "shows horse owned by the stable" do
      stable = create(:stable)
      user = stable.user
      horse1 = create(:horse, owner: stable)
      horse2 = create(:horse, owner: create(:stable))

      sign_in(user)
      visit stable_horse_path(horse1)
      expect(page).to have_text horse1.name
      expect(page).not_to have_text horse2.name
    end
  end

  context "when horse is not owned by the stable" do
    it "does not show horses" do
      stable = create(:stable)
      user = stable.user
      horse = create(:horse, owner: create(:stable))

      sign_in(user)
      visit stable_horse_path(horse)
      expect(page).to have_text "Not Found"
    end
  end
end

