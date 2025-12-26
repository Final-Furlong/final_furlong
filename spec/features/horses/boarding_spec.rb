RSpec.describe "Boarding" do
  before { setup_data }

  it "allows boarding to be started, shown, and stopped", :js do
    sign_in(user)

    visit horse_path(horse)
    choose "history"
    choose "boarding"
    expect(page).to have_text I18n.l(boarding.start_date)
    expect(page).to have_text boarding.location.name
    expect(page).to have_text t("horse.actions.boarding.stop")
    click_on t("view_components.nav.breadcrumbs.actions.title")
    within "#breadcrumb-actions" do
      click_on t("horse.actions.boarding.stop")
    end
    within "dialog" do
      click_on t("common.confirm.yes")
    end
    expect(page).not_to have_css "dialog"

    visit horse_path(horse)
    choose "history"
    choose "boarding"
    expect(page).not_to have_text t("horse.actions.boarding.stop")
  end

  private

  def setup_data
    boarding
  end

  def user
    @user ||= create(:user)
  end

  def stable
    @stable ||= user.stable
  end

  def horse
    return @horse if defined?(@horse)

    @horse = create(:horse, :racehorse, :with_appearance, owner: stable)
    Racing::LifetimeRaceRecord.refresh
    @horse
  end

  def boarding
    @boarding ||= create(:boarding, horse:, start_date: 2.days.ago, end_date: nil)
  end
end

