require "rails_helper"

RSpec.describe Account::StablePolicy do
  subject(:policy) { described_class.new(stable, user:) }

  let(:stable) { build(:stable) }

  describe "relation scope" do
    subject(:scope) { policy.apply_scope(Account::Stable.all, type: :active_record_relation) }

    let(:user) { build_stubbed(:user) }
    let(:active_stable) { create(:stable) }
    let(:inactive_stable) { create(:stable, user: build(:user, :pending)) }

    it "returns active stable" do
      expect(scope).to include(active_stable)
    end

    it "does not return inactive stable" do
      expect(scope).not_to include(inactive_stable)
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "allows public actions" do
      expect(policy).to allow_actions(:index, :show)
    end

    it "disallows private actions" do
      expect(policy).not_to allow_actions(:edit, :update, :destroy, :impersonate)
    end
  end

  context "when user is logged in and matches stable" do
    let(:user) { stable.user }

    it "allows private actions" do
      expect(policy).to allow_actions(:index, :show, :edit, :update)
    end

    it "disallows admin actions" do
      expect(policy).not_to allow_actions(:destroy, :impersonate)
    end
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    it "allows admin actions" do
      expect(policy).to allow_actions(:index, :show, :impersonate)
    end

    it "disallows private actions" do
      expect(policy).not_to allow_actions(:edit, :update, :destroy)
    end

    context "when dealing with own stable" do
      let(:user) { stable.user }

      before { user.update!(admin: true) }

      it "allows private actions" do
        expect(policy).to allow_actions(:show, :edit, :update)
      end

      it "disallows admin actions" do
        expect(policy).not_to allow_actions(:destroy, :impersonate)
      end
    end
  end
end

