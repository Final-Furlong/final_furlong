RSpec.describe Horses::LeaseOfferPolicy do
  subject(:policy) { described_class.new(user, offer) }

  let(:user) { create(:user) }
  let(:stable) { user.stable }
  let(:offer) { build_stubbed(:lease_offer) }

  describe "scope" do
    subject(:scope) { described_class::Scope.new(user, Horses::LeaseOffer.all).resolve }

    it "includes offers valid for the stable" do
      expect(scope).to eq Horses::LeaseOffer.valid_for_stable(user.stable)
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "does not allow inex" do
      expect(policy).not_to permit_actions(:index)
    end
  end

  context "when user is logged in" do
    let(:user) { create(:user) }

    it "allows index" do
      expect(policy).to permit_actions(:index)
    end
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    it "allows index" do
      expect(policy).to permit_actions(:index)
    end
  end
end

