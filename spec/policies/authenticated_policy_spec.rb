require "rails_helper"

RSpec.describe AuthenticatedPolicy do
  subject(:policy) { described_class.new(user, Account::User.new) }

  let(:user) { build_stubbed(:user) }

  context "when user is a visitor" do
    let(:user) { nil }

    it "forbids everything by default" do
      expect(policy).not_to permit_actions(*%i[index show new create edit update destroy])
    end
  end

  context "when user is logged in" do
    let(:user) { build_stubbed(:user) }

    it "allows everything by default" do
      expect(policy).to permit_actions(*%i[index show new create edit update destroy])
    end
  end
end

