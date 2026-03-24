RSpec.describe "Leasing Journey" do
  before { setup_data }

  it "allows lease to be offered, accepted, and cancelled early", :js do
    sign_in(leaser_user)

    visit horse_path(horse)
    click_on t("view_components.nav.breadcrumbs.actions.title")
    click_on t("horse.actions.create_lease_offer")
    within "dialog" do
      select "12", from: "horses_lease_offer[duration_months]"
      select leasee.name, from: "horses_lease_offer[leaser_id]"
      fill_in "horses_lease_offer[fee]", with: 10_000
      click_on t("common.actions.save")
    end
    expect(page).not_to have_css "dialog"
    expect(page).to have_text t("horse.lease_offers.create.success")
    sign_out(leaser_user)
    visit root_path

    sign_in(leasee_user)
    visit root_path
    within "#top_nav" do
      within "#notification-count" do
        expect(page).to have_text "1"
      end
      page.find(".notification-link").click
    end
    expect(page).to have_current_path(notifications_path)
    notification = LeaseOfferNotification.find_by!(user: leasee_user)
    expect(page).to have_text notification.message
    click_on t("horse.actions.lease_offer.accept")
    within "dialog" do
      click_on t("common.confirm.yes")
    end
    expect(page).to have_text t("horse.lease_offer_acceptances.create.success")
    expect(page).to have_text "Leased to #{leasee.name}"
    within ".drawer-side" do
      click_on t("layouts.sidenav.stable.budget")
    end
    expect(page).to have_text "Lease Fee: #{horse.name}"
    sign_out(leasee_user)
    visit root_path

    travel_to 6.months.from_now do
      sign_in(leasee_user)
      visit horse_path(horse)
      click_on t("view_components.nav.breadcrumbs.actions.title")
      click_on t("horse.actions.current_lease.terminate")
      within "dialog" do
        check "horses_lease_termination_request[leaser_accepted_end]"
        check "horses_lease_termination_request[leaser_accepted_refund]"
        click_on t("common.actions.save")
      end
      expect(page).not_to have_css("dialog")
      expect(page).to have_text t("horse.lease_terminations.create.success")
      expect(page).to have_text t("horses.info.lease_termination_requested")
      sign_out(leasee_user)
      visit root_path

      sign_in(leaser_user)
      visit horse_path(horse)
      click_on t("horse.actions.current_lease.terminate")
      within "dialog" do
        check "horses_lease_termination_request[owner_accepted_end]"
        check "horses_lease_termination_request[owner_accepted_refund]"
        click_on t("common.actions.save")
      end
      expect(page).not_to have_css("dialog")
      expect(page).to have_text t("horse.lease_terminations.create.success_with_termination")
      expect(page).not_to have_text t("horses.info.lease_termination_requested")
      within ".drawer-side" do
        click_on t("layouts.sidenav.stable.budget")
      end
      expect(page).to have_text "Lease Refund: #{horse.name}"
    end
  end

  it "allows lease to be offered, accepted, and cancelled early without javascript", js: false do
    sign_in(leaser_user)

    visit horse_path(horse)
    click_on t("horse.actions.create_lease_offer")
    expect(page).to have_current_path new_horse_lease_offer_path(horse), ignore_query: true
    select "12", from: "horses_lease_offer[duration_months]"
    select leasee.name, from: "horses_lease_offer[leaser_id]"
    fill_in "horses_lease_offer[fee]", with: 10_000
    click_on t("common.actions.save")
    expect(page).to have_text t("horse.lease_offers.create.success")
    sign_out(leaser_user)
    visit root_path

    sign_in(leasee_user)
    visit root_path
    within "#top_nav" do
      within "#notification-count" do
        expect(page).to have_text "1"
      end
      page.find(".notification-link").click
    end
    expect(page).to have_current_path(notifications_path)
    notification = LeaseOfferNotification.find_by!(user: leasee_user)
    expect(page).to have_text notification.message
    click_on t("horse.actions.lease_offer.accept")
    expect(page).to have_text t("horse.lease_offer_acceptances.create.success")
    expect(page).to have_text "Leased to #{leasee.name}"
    within ".drawer-side" do
      click_on t("layouts.sidenav.stable.budget")
    end
    expect(page).to have_text "Lease Fee: #{horse.name}"
    sign_out(leasee_user)
    visit root_path

    travel_to 6.months.from_now do
      sign_in(leasee_user)
      visit horse_path(horse)
      click_on t("horse.actions.current_lease.terminate")
      check "horses_lease_termination_request[leaser_accepted_end]"
      check "horses_lease_termination_request[leaser_accepted_refund]"
      click_on t("common.actions.save")
      expect(page).to have_text t("horse.lease_terminations.create.success")
      expect(page).to have_text t("horses.info.lease_termination_requested")
      sign_out(leasee_user)
      visit root_path

      sign_in(leaser_user)
      visit horse_path(horse)
      click_on t("horse.actions.current_lease.terminate")
      check "horses_lease_termination_request[owner_accepted_end]"
      check "horses_lease_termination_request[owner_accepted_refund]"
      click_on t("common.actions.save")
      expect(page).to have_text t("horse.lease_terminations.create.success_with_termination")
      expect(page).not_to have_text t("horses.info.lease_termination_requested")
      within ".drawer-side" do
        click_on t("layouts.sidenav.stable.budget")
      end
      expect(page).to have_text "Lease Refund: #{horse.name}"
    end
  end

  private

  def setup_data
    leaser
    leasee
    horse
  end

  def leaser_user
    @leaser_user ||= create(:user)
  end

  def leaser
    @leaser ||= leaser_user.stable
  end

  def leasee_user
    @leasee_user ||= create(:user)
  end

  def leasee
    return @leasee if defined?(@leasee)

    @leasee = leasee_user.stable
    @leasee.update(available_balance: 100_000, total_balance: 100_000)
    @leasee
  end

  def horse
    return @horse if defined?(@horse)

    @horse = create(:horse, :racehorse, :with_appearance, owner: leaser)
    Racing::LifetimeRaceRecord.refresh
    @horse
  end
end

