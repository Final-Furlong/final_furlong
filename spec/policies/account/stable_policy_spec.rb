require "rails_helper"

RSpec.describe Account::StablePolicy do
  subject { described_class.new(user, stable) }

  let(:stable) { build(:stable) }

  describe "::Scope" do
    let(:resolved_scope) do
      described_class::Scope.new(Account::User.new, Account::Stable.all).resolve
    end

    it "includes active stables based on scope" do
      expect(resolved_scope).to eq Account::StablesRepository.new(scope: Account::Stable.all).active
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it { is_expected.to permit_actions(%i[index show]) }
    it { is_expected.to forbid_actions(%i[edit update destroy impersonate]) }
  end

  context "when user is logged in and matches stable" do
    let(:user) { stable.user }

    it { is_expected.to permit_actions(%i[show edit update]) }
    it { is_expected.to forbid_actions(%i[destroy impersonate]) }
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to permit_actions(%i[show impersonate]) }
    it { is_expected.to forbid_actions(%i[edit update destroy]) }

    context "when dealing with own stable" do
      let(:user) { stable.user }

      before { user.update!(admin: true) }

      it { is_expected.to permit_actions(%i[show edit update]) }
      it { is_expected.to forbid_actions(%i[destroy impersonate]) }
    end
  end
end

