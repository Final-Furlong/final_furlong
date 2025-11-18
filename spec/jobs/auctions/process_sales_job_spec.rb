RSpec.describe Auctions::ProcessSalesJob, :perform_enqueued_jobs do
  describe "#perform" do
    before do
      allow(Auctions::HorseSeller).to receive(:new).and_return mock_seller
    end

    it "uses low_priority queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later(auction)
      end.to have_enqueued_job.on_queue("default")
    end

    context "when there are current high bids on horses" do
      it "triggers horse seller for each horse" do
        bid
        bid2
        allow(Auctions::HorseSeller).to receive(:new).and_return mock_seller
        described_class.perform_later(auction)
        expect(mock_seller).to have_received(:process_sale).with(bid:)
        expect(mock_seller).to have_received(:process_sale).with(bid: bid2)
      end
    end
  end

  private

  def mock_seller
    @mock_seller ||= instance_double(Auctions::HorseSeller, process_sale: true)
  end

  def bid
    return @bid if @bid
    result = insert_bid({ auction_id: auction.id,
                          horse_id: horse.id,
                          bidder_id: bidder.id,
                          current_bid: 10_000,
                          current_high_bid: true,
                          updated_at: DateTime.current - auction.hours_until_sold.hours - 1.second })

    @bid = Auctions::Bid.find(result.rows.flatten.first)
  end

  def bid2
    return @bid2 if @bid2
    result = insert_bid({ auction_id: auction.id,
                          horse_id: horse2.id,
                          bidder_id: bidder.id,
                          current_bid: 10_000,
                          current_high_bid: true,
                          updated_at: DateTime.current - auction.hours_until_sold.hours - 1.second })

    @bid2 = Auctions::Bid.find(result.rows.flatten.first)
  end

  def insert_bid(attrs)
    Auctions::Bid.insert(attrs)
  end

  def auction
    @auction ||= create(:auction, :current)
  end

  def horse
    @horse ||= create(:auction_horse, auction:)
  end

  def horse2
    @horse2 ||= create(:auction_horse, auction:)
  end

  def bidder
    @bidder ||= create(:stable)
  end

  def final_furlong
    name = "Final Furlong"
    @final_furlong ||= Account::Stable.find_by(name:) || create(:stable, name:)
  end
end

