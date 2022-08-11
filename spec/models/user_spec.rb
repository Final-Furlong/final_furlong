RSpec.describe User, type: :model do
  describe "callbacks" do
    describe "#before_validation" do
      it "sets status to pending" do
        user = build(:user, :without_stable, status: nil)

        expect { user.valid? }.to change(user, :status).from(nil).to("pending")
      end

      it "sets admin to false" do
        user = build(:user, :without_stable, admin: nil)

        expect { user.valid? }.to change(user, :admin).from(nil).to(false)
      end

      it "does not override pre-set values" do
        user = build(:admin, :without_stable, status: "banned")

        expect { user.valid? }.not_to change { user }
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_one :activation }
    it { is_expected.to have_one :stable }
    it { is_expected.to have_one :setting }
  end
end
