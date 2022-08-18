require "rails_helper"

RSpec.describe HorsePolicy do
  subject { described_class.new(user, horse) }

  let(:horse) { build_stubbed(:horse) }

  describe "::Scope" do
    let(:resolved_scope) do
      described_class::Scope.new(User.new, Horse.all).resolve
    end

    it "includes born horses" do
      expect(resolved_scope).to eq Horse.born
    end
  end

  shared_examples "not permitting anything for an unborn horse" do
    let(:horse) { build_stubbed(:horse, :unborn) }

    it { is_expected.to forbid_action(:show) }
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it { is_expected.to permit_actions(%i[index show]) }

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is logged in and matches stable" do
    let(:user) { create(:user) }

    it { is_expected.to permit_actions(%i[index show]) }

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to permit_actions(%i[index show]) }

    it_behaves_like "not permitting anything for an unborn horse"
  end
end

