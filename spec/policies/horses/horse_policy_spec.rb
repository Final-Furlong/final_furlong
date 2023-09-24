require "rails_helper"

RSpec.describe Horses::HorsePolicy do
  subject(:policy) { described_class.new(horse, user: user) }

  let(:user) { build_stubbed(:user) }
  let(:horse) { build_stubbed(:horse) }

  describe "relation scope" do
    subject(:scope) { policy.apply_scope(Horses::Horse.all, type: :active_record_relation) }

    it "includes born horses" do
      expect(scope).to eq Horses::HorsesQuery.new.born
    end
  end

  shared_examples "not permitting anything for an unborn horse" do
    let(:horse) { build_stubbed(:horse, :unborn) }

    it "does not allow show" do
      expect(policy).not_to allow_actions(:show)
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "allows public actions" do
      expect(policy).to allow_actions(:index, :show)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is logged in and matches stable" do
    let(:user) { create(:user) }

    it "allows public actions" do
      expect(policy).to allow_actions(:index, :show)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    it "allows public actions" do
      expect(policy).to allow_actions(:index, :show)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end
end

