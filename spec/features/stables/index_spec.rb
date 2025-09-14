RSpec.describe "Stable Index" do
  it "allows viewing as anonymous user" do
    visit stables_path
    expect(page).to have_text t("stables.index.all")
  end

  it "allows viewing as user" do
    sign_in(create(:user))
    visit stables_path
    within("#main-navbar") do
      expect(page).not_to have_link t("layouts.nav.login")
    end
    expect(page).to have_text t("stables.index.all")
  end

  it "shows all stables" do
    stable = create(:stable)
    stable2 = create(:stable)

    visit stables_path
    expect(page).to have_link stable.name, href: stable_path(stable)
    expect(page).to have_link stable2.name, href: stable_path(stable2)
  end

  it "shows online status" do
    stable = create(:stable, last_online_at: 1.minute.ago)

    visit stables_path
    within("#account_stable_#{stable.id}") do
      expect(page).to have_link stable.name, href: stable_path(stable)
      expect(page).to have_text t("view_components.users.online_badge.online")
    end
  end

  it "is accessible", :axe do
    visit stables_path
    expect(page).to be_axe_clean
  end
end

