RSpec.describe Auctions::Bid do
  describe "associations" do
    it { is_expected.to belong_to(:auction).class_name("::Auction") }
    it { is_expected.to belong_to(:horse).class_name("Auctions::Horse") }
    it { is_expected.to belong_to(:bidder).class_name("Account::Stable") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:current_bid) }
    it { is_expected.to validate_numericality_of(:current_bid).is_greater_than_or_equal_to(described_class::MINIMUM_BID) }

    describe "maximum bid" do
      it "can be blank" do
        bid = create(:auction_bid)
        expect(bid).to be_valid
      end

      it "cannot be less than current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 1001
        bid.maximum_bid = 1000
        expect(bid).not_to be_valid
      end

      it "can be equal to current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 1000
        bid.maximum_bid = 1000
        expect(bid).to be_valid
      end

      it "can be greater than current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 1000
        bid.maximum_bid = 1200
        expect(bid).to be_valid
      end
    end
  end

  describe "callbacks" do
    before { ActiveJob::Base.queue_adapter = :solid_queue }

    after { ActiveJob::Base.queue_adapter = :test }

    context "when bid is destroyed" do
      it "deletes enqueued process auction sale job" do
        bid = create(:auction_bid)
        Auctions::ProcessSalesJob.set(wait: bid.auction.hours_until_sold.hours).perform_later(
          bid:, horse: bid.horse, auction: bid.auction, bidder: bid.bidder
        )
        last_job = SolidQueue::Job.order(id: :desc).first
        expect do
          bid.destroy
        end.to change(SolidQueue::Job, :count).by(-1)
        expect(SolidQueue::Job.exists?(id: last_job.id)).to be false
      end
    end
  end

  private

  def global_id_string(object)
    object.to_global_id.to_s
  end
end

