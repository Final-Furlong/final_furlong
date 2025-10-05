RSpec.describe Api::V1::AuctionBids do
  describe "POST /api/v1/auction_bids" do
    context "when bid creation works" do
      it "returns bid ID" do
        mock_result = Auctions::BidCreator::Result.new(created: true, auction:, horse:, bid: create(:auction_bid))
        mock_creator = instance_double(Auctions::BidCreator, create_bid: mock_result)
        allow(Auctions::BidCreator).to receive(:new).and_return mock_creator

        post("/api/v1/auction_bids", params:)

        expect(response).to have_http_status :created
        expect(json_body).to eq({ bid_id: mock_result.bid.id })
      end
    end

    context "when bid creation works but bid is nil" do
      it "returns bid ID" do
        mock_result = Auctions::BidCreator::Result.new(created: true, auction:, horse:, bid: nil)
        mock_creator = instance_double(Auctions::BidCreator, create_bid: mock_result)
        allow(Auctions::BidCreator).to receive(:new).and_return mock_creator

        post("/api/v1/auction_bids", params:)

        expect(response).to have_http_status :created
        expect(json_body).to eq({ bid_id: nil })
      end
    end

    context "when bid creation fails" do
      it "returns error" do
        error = SecureRandom.alphanumeric(20)
        mock_result = Auctions::BidCreator::Result.new(created: false, auction:, horse:, bid: nil, error:)
        mock_creator = instance_double(Auctions::BidCreator, create_bid: mock_result)
        allow(Auctions::BidCreator).to receive(:new).and_return mock_creator

        post("/api/v1/auction_bids", params:)

        expect(response).to have_http_status :internal_server_error
        expect(json_body).to eq({ error: "invalid", detail: error })
      end
    end
  end

  private

  def params
    {
      auction_id: auction.id,
      horse_id: horse.id,
      bidder_id: bidder.id,
      current_bid: 2000,
      maximum_bid: 2000
    }
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
end

