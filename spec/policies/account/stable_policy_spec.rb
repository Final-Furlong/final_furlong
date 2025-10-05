RSpec.describe Account::StablePolicy do
  subject(:policy) { described_class.new(user, stable) }

  let(:stable) { build(:stable) }

  describe "scope" do
    subject(:scope) { described_class::Scope.new(user, Account::Stable.all).resolve }

    let(:user) { build_stubbed(:user) }
    let(:active_stable) { create(:stable) }
    let(:inactive_stable) { create(:stable, user: build(:user, :pending)) }

    it "returns active stable" do
      expect(scope).to include(active_stable)
    end

    it "does not return inactive stable" do
      expect(scope).not_to include(inactive_stable)
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "allows public actions" do
      expect(policy).to permit_actions(:index, :show)
    end

    it "disallows private actions" do
      expect(policy).not_to permit_actions(:edit, :update, :destroy, :impersonate)
    end
  end

  context "when user is logged in and matches stable" do
    let(:user) { stable.user }

    it "allows private actions" do
      expect(policy).to permit_actions(:index, :show, :edit, :update)
    end

    it "disallows admin actions" do
      expect(policy).not_to permit_actions(:destroy, :impersonate)
    end
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    it "allows admin actions" do
      expect(policy).to permit_actions(:index, :show, :impersonate)
    end

    it "disallows private actions" do
      expect(policy).not_to permit_actions(:edit, :update, :destroy)
    end

    context "when dealing with own stable" do
      let(:user) { stable.user }

      before { user.update!(admin: true) }

      it "allows private actions" do
        expect(policy).to permit_actions(:show, :edit, :update)
      end

      it "disallows admin actions" do
        expect(policy).not_to permit_actions(:destroy, :impersonate)
      end
    end
  end
end

