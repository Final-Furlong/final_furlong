RSpec.describe Account::Stable do
  describe "associations" do
    subject(:stable) { described_class.new }

    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:horses).class_name("Horses::Horse").inverse_of(:owner) }
    it { is_expected.to have_many(:bred_horses).class_name("Horses::Horse").inverse_of(:breeder) }
    it { is_expected.to have_many(:training_schedules).class_name("Racing::TrainingSchedule").inverse_of(:stable) }
    it { is_expected.to have_many(:auctions).class_name("Auction").inverse_of(:auctioneer).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:auction_bids).class_name("Auctions::Bid").inverse_of(:bidder).dependent(:destroy) }
  end

  describe ".ransackable_attributes" do
    it "contains the right fields" do
      expect(described_class.ransackable_attributes).to match_array(
                                                          %w[bred_horses_count description horses_count name unborn_horses_count]
                                                        )
    end
  end

  describe "#newbie?" do
    context "when created_at is within the last year" do
      it "returns true" do
        stable = build_stubbed(:stable, created_at: 9.months.ago)
        expect(stable.newbie?).to be true
      end
    end

    context "when created_at is later than a year ago" do
      it "returns false" do
        stable = build_stubbed(:stable, created_at: 366.days.ago)
        expect(stable.newbie?).to be false
      end
    end
  end

  describe "#second_year?" do
    context "when created_at is within the year before last" do
      it "returns true" do
        stable = build_stubbed(:stable, created_at: 23.months.ago)
        expect(stable.second_year?).to be true
      end
    end

    context "when created_at is later than 2 years ago" do
      it "returns false" do
        stable = build_stubbed(:stable, created_at: 25.months.ago)
        expect(stable.second_year?).to be false
      end
    end
  end
end

