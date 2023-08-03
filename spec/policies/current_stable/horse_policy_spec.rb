require "rails_helper"

RSpec.describe CurrentStable::HorsePolicy do
  subject(:policy) { described_class.new(Horses::Horse.new, user: user) }

  let(:user) { create(:user) }

  describe "#relation scope" do
    subject(:scope) { policy.apply_scope(Horses::Horse.all, type: :relation) }

    let(:stable) { user.stable }
    let(:owned_horse) { create(:horse, owner: stable) }
    let(:unowned_horse) { create(:horse, owner: create(:stable)) }

    it "includes owned living horses" do
      relation = Horses::HorsesRepository.new.owned_by(stable)
      expected_scope = Horses::HorsesRepository.new(scope: relation).living

      expect(scope).to eq expected_scope
    end
  end
end

