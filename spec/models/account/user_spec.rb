RSpec.describe Account::User do
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

  describe ".ransackable_attributes" do
    subject(:attrs) { described_class.ransackable_attributes }

    it { is_expected.to match_array(%w[username status name email]) }
  end

  describe ".find_for_database_authentication" do
    it "returns first matching user by username" do
      username = create(:user, username: "bob@example.com", created_at: 1.day.ago)
      create(:user, email: "bob@example.com")

      result = described_class.find_for_database_authentication({ login: "BOB@EXAMPLE.com" })
      expect(result).to eq username
    end

    it "returns first matching user by email" do
      email = create(:user, email: "bob@example.com", created_at: 1.day.ago)
      create(:user, username: "bob@example.com")

      result = described_class.find_for_database_authentication({ login: "BOB@EXAMPLE.com" })
      expect(result).to eq email
    end
  end
end

