RSpec.describe NilClassPolicy do
  subject(:policy) { described_class.new(user, Account::User.new) }

  let(:user) { build_stubbed(:user) }

  describe "scope" do
    subject(:scope) { described_class::Scope.new(user, Account::Stable.all).resolve }

    let(:user) { build_stubbed(:user) }

    it "raises error" do
      expect { scope }.to raise_error Pundit::NotDefinedError, "Cannot scope NilClass"
    end
  end

  it "forbids everything by default" do
    expect(policy).not_to permit_actions(*%i[index show new create edit update destroy])
  end
end

