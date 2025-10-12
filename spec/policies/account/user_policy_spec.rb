require "spec_helper"

RSpec.describe Account::UserPolicy do
  subject(:policy) { described_class.new(user, subject_user) }

  let(:user) { build_stubbed(:user) }
  let(:subject_user) { build_stubbed(:user) }

  describe "scope" do
    subject(:scope) { described_class::Scope.new(user, Account::User.all).resolve }

    let(:user) { build_stubbed(:user) }
    let(:active_user) { create(:user) }
    let(:inactive_user) { create(:user, :pending) }

    it "returns active user" do
      expect(scope).to include(active_user)
    end

    it "does not return inactive user" do
      expect(scope).not_to include(inactive_user)
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "disallows admin actions" do
      expect(policy).not_to permit_actions(:index, :create, :impersonate)
    end
  end

  context "when user is not admin" do
    it "disallows admin actions" do
      expect(policy).not_to permit_actions(:index, :create, :impersonate)
    end
  end

  context "when user is an admin" do
    let(:user) { build_stubbed(:admin) }

    it "allows admin actions" do
      expect(policy).to permit_actions(:index, :create, :impersonate)
    end

    context "when dealing with own account" do
      let(:subject_user) { user }

      it "allows actions" do
        expect(policy).to permit_actions(:create)
      end

      it "disallows actions" do
        expect(policy).not_to permit_actions(:impersonate)
      end
    end

    describe "#permitted_attributes" do
      let(:permitted_attrs) { %i[name email] }
      let(:forbidden_attrs) { %i[username password password_confirmation stable_name] }
      let(:create_attrs) { %i[username name email password password_confirmation stable_name] }

      it { is_expected.to permit_mass_assignment_of(permitted_attrs) }
      it { is_expected.to forbid_mass_assignment_of(forbidden_attrs) }
      it { is_expected.to permit_mass_assignment_of(create_attrs).for_action(:create) }
    end
  end
end

