RSpec.describe CurrentStable::PushSubscriptionsPolicy do
  subject(:policy) { described_class.new(user, Account::User.new) }

  let(:user) { create(:user) }

  context "when user is active" do
    it "allows create" do
      expect(policy).to permit_actions(:create, :change)
    end
  end

  context "when user is not active" do
    let(:user) { create(:user, :pending) }

    it "does not allow anything" do
      expect(policy).not_to permit_actions(:create, :change)
    end
  end
end

