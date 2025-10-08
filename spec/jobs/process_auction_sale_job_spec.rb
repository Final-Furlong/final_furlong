RSpec.describe ProcessAuctionSaleJob, :perform_enqueued_jobs do
  describe "#perform" do
    before do
      allow(Auctions::HorseSeller).to receive(:new).and_return mock_seller
    end

    it "uses low_priority queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later(bid:, auction:, horse:, bidder:)
      end.to have_enqueued_job.on_queue("default")
    end

    context "when horse is sold" do
      it "does not trigger horse seller" do
        horse.update(sold_at: Time.current)
        described_class.perform_later(bid:, auction:, horse:, bidder:)
        expect(Auctions::HorseSeller).not_to have_received(:new)
      end
    end

    context "when winning bid is not equal to params bid" do
      before do
        result = insert_bid({ auction_id: auction.id,
                              horse_id: horse.id,
                              bidder_id: create(:stable).id,
                              current_bid: 15_000 })
        @winning_bid = Auctions::Bid.find(result.rows.flatten.first)
      end

      it "trigger horse seller with other bid" do
        described_class.perform_later(bid:, auction:, horse:, bidder:)
        expect(mock_seller).to have_received(:process_sale).with(bid: @winning_bid)
      end
    end

    context "when winning bid is equal to params bid" do
      it "triggers horse seller" do
        described_class.perform_later(bid:, auction:, horse:, bidder:)
        expect(mock_seller).to have_received(:process_sale).with(bid:)
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
                          current_bid: 10_000 })

    @bid = Auctions::Bid.find(result.rows.flatten.first)
  end

  def insert_bid(attrs)
    # rubocop:disable Rails/SkipsModelValidations
    Auctions::Bid.insert(attrs)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def auction
    @auction ||= create(:auction, :current)
  end

  def horse
    @horse ||= create(:auction_horse, auction:)
  end

  def bidder
    @bidder ||= create(:stable)
  end

  def final_furlong
    name = "Final Furlong"
    @final_furlong ||= Account::Stable.find_by(name:) || create(:stable, name:)
  end
end

