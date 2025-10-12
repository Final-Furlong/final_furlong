RSpec.describe CurrentStable::SettingsPolicy do
  subject(:policy) { described_class.new(user, Account::User.new) }

  let(:user) { create(:user) }

  it "allows new" do
    expect(policy).to permit_action(:new)
  end

  context "when user is not saved to the database" do
    let(:user) { Account::User.new }

    it "does not allow anything" do
      expect(policy).not_to permit_action(:new)
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "does not allow anything" do
      expect(policy).not_to permit_action(:new)
    end
  end
end

