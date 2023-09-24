RSpec.describe Account::User do
  describe "attributes" do
    it "sets status to pending" do
      expect(described_class.new.status).to eq "pending"
    end

    it "sets admin to false" do
      expect(described_class.new.admin).to be false
    end

    it "does not override pre-set values" do
      user = described_class.new(status: "banned", admin: true)

      expect(user).to have_attributes(status: "banned", admin: true)
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

