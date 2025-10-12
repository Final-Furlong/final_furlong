RSpec.describe CurrentStable::HorsePolicy do
  subject(:policy) { described_class.new(user, horse) }

  describe "#scope" do
    subject(:scope) { described_class::Scope.new(user, Horses::Horse.all).resolve }

    it "includes owned living horses" do
      expect(scope).to eq Horses::HorsesQuery.new.owned_by(stable).living
    end
  end

  context "when user owns the horse" do
    it "allows show" do
      horse.owner = user.stable
      expect(policy).to permit_action(:show)
    end
  end

  context "when user does not own the horse" do
    it "allows show" do
      expect(policy).not_to permit_action(:show)
    end
  end

  private

  def user
    @user ||= create(:user)
  end

  def horse
    @horse ||= build(:horse)
  end

  def stable
    @stable ||= user.stable
  end

  def owned_horse
    @owned_horse ||= create(:horse, owner: stable)
  end

  def unowned_horse
    @unowned_horse ||= create(:horse, owner: create(:stable))
  end
end

