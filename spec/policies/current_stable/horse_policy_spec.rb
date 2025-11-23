RSpec.describe CurrentStable::HorsePolicy do
  subject(:policy) { described_class.new(user, horse) }

  describe "#scope" do
    subject(:scope) { described_class::Scope.new(user, Horses::Horse.all).resolve }

    it "includes owned living horses" do
      expect(scope).to eq Horses::HorsesQuery.new.owned_by(stable).living
    end
  end

  context "when user owns the horse" do
    it "allows correct actions" do
      horse.owner = user.stable
      expect(policy).to permit_actions(:show, :view_events, :view_sales,
        :view_shipping, :view_workouts, :view_boarding, :ship)
    end

    context "when the horse is a broodmare" do
      before { horse.status = "broodmare" }

      it "denies correct actions" do
        horse.owner = user.stable
        expect(policy).not_to permit_actions(:view_workouts, :view_boarding)
      end
    end

    context "when the horse is a stud" do
      before { horse.status = "stud" }

      it "denies correct actions" do
        horse.owner = user.stable
        expect(policy).not_to permit_actions(:view_shipping, :view_workouts,
          :view_boarding, :ship)
      end
    end
  end

  context "when user leases the horse" do
    it "allows correct actions" do
      create(:lease, horse:, leaser: user.stable)
      expect(policy).to permit_actions(:show, :view_events, :view_sales,
        :view_shipping, :view_workouts, :view_boarding)
    end

    context "when the horse is a broodmare" do
      before { horse.status = "broodmare" }

      it "denies correct actions" do
        create(:lease, horse:, leaser: user.stable)
        expect(policy).not_to permit_actions(:view_workouts, :view_boarding)
      end
    end

    context "when the horse is a stud" do
      before { horse.status = "stud" }

      it "denies correct actions" do
        create(:lease, horse:, leaser: user.stable)
        expect(policy).not_to permit_actions(:view_shipping, :view_workouts,
          :view_boarding)
      end
    end
  end

  context "when user does not own the horse" do
    it "allows correct actions" do
      expect(policy).to permit_action(:view_sales)
    end

    it "denies correct actions" do
      expect(policy).not_to permit_actions(:show, :view_shipping,
        :view_workouts, :view_boarding)
    end
  end

  context "when user is visitor" do
    let(:user) { nil }

    it "denies correct actions" do
      expect(policy).not_to permit_actions(:show, :view_events, :view_sales,
        :view_workouts, :view_boarding)
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

