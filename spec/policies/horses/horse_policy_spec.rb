require "rails_helper"

RSpec.describe Horses::HorsePolicy do
  subject(:policy) { described_class.new(user, horse) }

  let(:user) { build_stubbed(:user) }
  let(:horse) { build_stubbed(:horse) }

  describe "scope" do
    subject(:scope) { described_class::Scope.new(user, Horses::Horse.all).resolve }

    it "includes born horses" do
      expect(scope).to eq Horses::HorsesQuery.new.born
    end
  end

  shared_examples "not permitting anything for an unborn horse" do
    let(:horse) { build_stubbed(:horse, :unborn) }

    it "does not allow show" do
      expect(policy).not_to permit_actions(:show)
    end

    it "does not allow show" do
      expect(policy).not_to permit_actions(:image, :thumbnail)
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "allows public actions" do
      expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is logged in and matches stable" do
    let(:user) { create(:user) }

    it "allows public actions" do
      expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    it "allows public actions" do
      expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end
end

