RSpec.describe ApplicationPolicy do
  subject(:policy) { described_class.new(user, Account::User.new) }

  let(:user) { build_stubbed(:user) }

  describe "scope" do
    subject(:scope) { described_class::Scope.new(user, Account::Stable.all).resolve }

    let(:user) { build_stubbed(:user) }

    it "raises error" do
      expect { scope }.to raise_error NoMethodError
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "forbids everything by default" do
      expect(policy).not_to permit_actions(*%i[index show new create edit update destroy])
    end
  end

  context "when user is logged in and matches stable" do
    let(:user) { build_stubbed(:user) }

    it "forbids everything by default" do
      expect(policy).not_to permit_actions(*%i[index show new create edit update destroy])
    end
  end

  context "when user is an admin" do
    let(:user) { build_stubbed(:admin) }

    it "forbids everything by default" do
      expect(policy).not_to permit_actions(*%i[index show new create edit update destroy])
    end
  end
end

