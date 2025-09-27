RSpec.describe Account::Stable do
  describe "associations" do
    subject(:stable) { described_class.new }

    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:horses).class_name("Horses::Horse").inverse_of(:owner) }
    it { is_expected.to have_many(:bred_horses).class_name("Horses::Horse").inverse_of(:breeder) }
    it { is_expected.to have_many(:training_schedules).class_name("Racing::TrainingSchedule").inverse_of(:stable) }
    it { is_expected.to have_many(:auctions).class_name("Auction").inverse_of(:auctioneer).dependent(:restrict_with_exception) }
    it { is_expected.to have_many(:auction_bids).class_name("Auctions::Bid").inverse_of(:bidder).dependent(:delete_all) }
  end

  describe ".ransackable_attributes" do
    it "contains the right fields" do
      expect(described_class.ransackable_attributes).to match_array(
                                                          %w[bred_horses_count description horses_count name unborn_horses_count]
                                                        )
    end
  end
end

