require "rails_helper"

RSpec.describe ApplicationPolicy do
  subject { described_class.new(user, Account::User.new) }

  let(:user) { build_stubbed(:user) }

  describe "::Scope" do
    let(:scope) { described_class::Scope.new(user, Account::User.new) }

    describe "#resolve" do
      it "raises error" do
        expect { scope.resolve }.to raise_error NotImplementedError
      end
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[index show new create edit update destroy]) }
  end

  context "when user is logged in and matches stable" do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to forbid_actions(%i[index show new create edit update destroy]) }
  end

  context "when user is an admin" do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to forbid_actions(%i[index show new create edit update destroy]) }
  end
end

