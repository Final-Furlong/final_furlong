RSpec.describe "Create Auction" do
  it "cannot create as visitor" do
    visit new_auction_path

    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end

  context "when user is signed in" do
    before { sign_in(user) }

    it "allows user to create an auction" do
      visit new_auction_path
      fill_in "auction[title]", with: "#{stable.name} Auction"
      #  broodmare_allowed             :boolean          default(FALSE), not null
      #  end_time                      :datetime         not null, indexed
      #  horse_purchase_cap_per_stable :integer
      #  hours_until_sold              :integer          default(12), not null
      #  outside_horses_allowed        :boolean          default(FALSE), not null
      #  racehorse_allowed_2yo         :boolean          default(FALSE), not null
      #  racehorse_allowed_3yo         :boolean          default(FALSE), not null
      #  racehorse_allowed_older       :boolean          default(FALSE), not null
      #  reserve_pricing_allowed       :boolean          default(FALSE), not null
      #  spending_cap_per_stable       :integer
      #  stallion_allowed              :boolean          default(FALSE), not null
      #  start_time                    :datetime         not null, indexed
      #  title                         :string           not null
      #  weanling_allowed              :boolean          default(FALSE), not null
      #  yearling_allowed              :boolean          default(FALSE), not null
      #  created_at                    :datetime         not null
      #  updated_at                    :datetime         not null
      #  auctioneer_id                 :uuid             indexed
      click_on t("auctions.form.save")
      expect(page).to have_current_path current_stable_path, ignore_query: true
      expect(page).to have_text updated_description
    end

    it "does not an auction with errors"

    it "is accessible", :axe do
      visit new_auction_path
      expect(page).to be_axe_clean
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

