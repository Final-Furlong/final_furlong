require "rails_helper"

RSpec.describe ApplicationPolicy do
  subject(:policy) { described_class.new(Account::User.new, user: user) }

  let(:user) { build_stubbed(:user) }

  context "when user is a visitor" do
    let(:user) { nil }

    it "forbids everything by default" do
      expect(policy).not_to allow_actions(*%i[index show new create edit update destroy])
    end
  end

  context "when user is logged in and matches stable" do
    let(:user) { build_stubbed(:user) }

    it "forbids everything by default" do
      expect(policy).not_to allow_actions(*%i[index show new create edit update destroy])
    end
  end

  context "when user is an admin" do
    let(:user) { build_stubbed(:admin) }

    it "forbids everything by default" do
      expect(policy).not_to allow_actions(*%i[index show new create edit update destroy])
    end
  end
end

