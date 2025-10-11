RSpec.describe Api::V1::AuctionHorses do
  describe "POST /api/v1/auction_horses" do
    context "when horse creation works" do
      it "returns auction horse ID" do
        mock_result = Auctions::HorseCreator::Result.new(created: true, auction:, horse: create(:auction_horse), stable:)
        mock_creator = instance_double(Auctions::HorseCreator, create_horse: mock_result)
        allow(Auctions::HorseCreator).to receive(:new).and_return mock_creator

        post("/api/v1/auction_horses", params:)

        expect(response).to have_http_status :created
        expect(json_body).to eq({ auction_horse_id: mock_result.horse.id })
      end
    end

    context "when horse creation fails" do
      it "returns error" do
        error = SecureRandom.alphanumeric(20)
        mock_result = Auctions::HorseCreator::Result.new(created: false, auction:, horse: nil, stable:, error:)
        mock_creator = instance_double(Auctions::HorseCreator, create_horse: mock_result)
        allow(Auctions::HorseCreator).to receive(:new).and_return mock_creator

        post("/api/v1/auction_horses", params:)

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
      stable_id: stable.id,
      reserve_price: 2000,
      comment: "foo"
    }
  end

  def auction
    @auction ||= create(:auction, reserve_pricing_allowed: true)
  end

  def horse
    @horse ||= create(:horse, owner: stable)
  end

  def stable
    @stable ||= create(:stable)
  end
end

