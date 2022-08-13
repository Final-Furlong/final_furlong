require "rails_helper"

RSpec.describe StablePolicy do
  subject { described_class.new(user, stable) }

  let(:stable) { build(:stable) }

  describe "::Scope" do
    let(:resolved_scope) do
      described_class::Scope.new(User.new, Stable.all).resolve
    end

    it "includes active stables based on scope" do
      expect(resolved_scope).to eq StablesRepository.new(scope: Stable.all).active
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

    it { is_expected.to permit_actions(%i[show destroy impersonate]) }
    it { is_expected.to forbid_actions(%i[edit update]) }

    context "when dealing with own stable" do
      let(:user) { stable.user }

      before { user.update!(admin: true) }

      it { is_expected.to forbid_action(:impersonate) }
    end
  end
end

