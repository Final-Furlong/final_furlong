RSpec.describe "Impersonate Stable Index" do
  it "does not allow impersonating as visitor" do
    user = create(:user, :without_stable, email: "user@example.com", username: "user123")
    stable = create(:stable, user:)

    visit stables_path
    click_link stable.name
    expect(page).to have_current_path stable_path(stable), ignore_query: true
    expect(page).not_to have_link t("view_components.nav.breadcrumbs.impersonate")
  end

  it "does not allow impersonating as non-admin user" do
    sign_in(create(:user))
    user = create(:user, :without_stable, email: "user@example.com", username: "user123")
    stable = create(:stable, user:)

    visit stables_path
    expect(page).to have_link stable.name, href: stable_path(stable)
    click_link stable.name
    expect(page).to have_current_path stable_path(stable), ignore_query: true
    expect(page).not_to have_link t("view_components.nav.breadcrumbs.impersonate")
  end

  it "does allow impersonating as admin user" do
    admin = create(:admin, :without_stable)
    admin_stable = create(:stable, user: admin)
    sign_in(admin)
    user = create(:user, :without_stable, email: "user@example.com", username: "user123")
    stable = create(:stable, user:)

    visit stables_path
    click_link stable.name
    expect(page).to have_current_path stable_path(stable), ignore_query: true
    within("#breadcrumb-actions") do
      click_on t("view_components.nav.breadcrumbs.impersonate"), visible: true
    end
    expect(page).to have_css "#impersonation-alert"
    expect(page).to have_current_path root_path, ignore_query: true
    expect(page).to have_text t("view_components.users.impersonating_banner.title", stable: stable.name, username: user.username)
    expect(page).to have_text t("view_components.users.online_badge.offline")
    click_on t("view_components.users.impersonating_banner.sign_out")
    expect(page).to have_current_path root_path, ignore_query: true
    expect(page).not_to have_css "#impersonation-alert"
    expect(page).to have_text t("users.stop_impersonating.success")
    expect(page).to have_text admin_stable.name
  end
end

