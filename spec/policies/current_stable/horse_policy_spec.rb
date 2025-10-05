RSpec.describe CurrentStable::HorsePolicy do
  subject(:policy) { described_class.new(Horses::Horse.new, user) }

  let(:user) { create(:user) }

  describe "#scope" do
    subject(:scope) { described_class::Scope.new(user, Horses::Horse.all).resolve }

    let(:stable) { user.stable }
    let(:owned_horse) { create(:horse, owner: stable) }
    let(:unowned_horse) { create(:horse, owner: create(:stable)) }

    it "includes owned living horses" do
      expect(scope).to eq Horses::HorsesQuery.new.owned_by(stable).living
    end
  end
end

