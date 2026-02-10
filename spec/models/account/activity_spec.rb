RSpec.describe Account::Activity do
  describe "associations" do
    it { is_expected.to belong_to(:stable) }
    it { is_expected.to belong_to(:budget).optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:activity_type) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:balance) }
    it { is_expected.to validate_presence_of(:legacy_stable_id) }
    it { is_expected.to validate_inclusion_of(:activity_type).in_array(Config::Game.activity_types) }
  end

  describe "scopes" do
    describe ".recent" do
      it "returns results ordered by created at desc" do
        activity1 = create(:activity)
        activity2 = create(:activity, created_at: 1.day.ago)

        expect(described_class.recent).to eq([activity1, activity2])
      end
    end
  end
end

