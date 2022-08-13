require "spec_helper"

RSpec.describe UserPolicy do
  subject(:policy) { described_class.new(user, subject_user) }

  let(:user) { build_stubbed(:user) }
  let(:subject_user) { build_stubbed(:user) }

  describe "::Scope" do
    let(:resolved_scope) do
      described_class::Scope.new(User.new, User.all).resolve
    end

    it "includes active users" do
      expect(resolved_scope).to eq UsersRepository.new.active
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[create impersonate]) }
  end

  context "when user is not admin" do
    it { is_expected.to forbid_actions(%i[create impersonate]) }
  end

  context "when user is an admin" do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_actions(%i[create impersonate]) }

    context "when dealing with own account" do
      let(:subject_user) { user }

      it { is_expected.to permit_action(:create) }
      it { is_expected.to forbid_action(:impersonate) }
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

