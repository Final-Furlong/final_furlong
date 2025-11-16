RSpec.describe "Leasing Journey" do
  it "allows lease to be offered, accepted, and cancelled early" do
    leaser_user = create(:user)
    leaser = leaser_user.stable
    leasee_user = create(:user)
    leasee = leasee_user.stable
    leasee.update(available_balance: 100_000, total_balance: 100_000)
    horse = create(:horse, :racehorse, :with_appearance, owner: leaser)
    Racing::LifetimeRaceRecord.refresh

    sign_in(leaser_user)

    visit horse_path(horse)
    click_on t("horses.show.actions")
    click_on t("horse.actions.create_lease_offer")
    expect(page).to have_current_path new_lease_offer_path(horse), ignore_query: true
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
    accept_confirm do
      click_on t("horse.actions.lease_offer.accept")
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
      click_on t("horses.show.actions")
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
      click_on t("horses.show.actions")
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
end

