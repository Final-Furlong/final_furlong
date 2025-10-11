RSpec.describe Auctions::MixedAuctionCreator do
  context "when auction params are invalid" do
    it "returns created false result" do
      result = described_class.new.create_auction(auction_params.merge(title: nil))
      expect(result.created?).to be false
    end

    it "does not create auction" do
      expect do
        described_class.new.create_auction(auction_params.merge(title: nil))
      end.not_to change(Auction, :count)
    end

    it "returns auction with errors" do
      result = described_class.new.create_auction(auction_params.merge(title: nil))
      expect(result.auction.errors[:title]).to contain_exactly("can't be blank", "is too short (minimum is 10 characters)")
    end
  end

  context "when auctioneer is not FF" do
    it "returns created false result" do
      result = described_class.new.create_auction(auction_params.merge(auctioneer: other_stable))
      expect(result.created?).to be false
    end

    it "does not create auction" do
      expect do
        described_class.new.create_auction(auction_params.merge(auctioneer: other_stable))
      end.not_to change(Auction, :count)
    end

    it "returns auction with errors" do
      result = described_class.new.create_auction(auction_params.merge(auctioneer: other_stable))
      expect(result.auction.errors[:auctioneer]).to eq(["is invalid"])
    end
  end

  context "when auction params are valid" do
    it "returns created true result" do
      result = described_class.new.create_auction(auction_params)
      expect(result.created?).to be true
    end

    it "creates auction" do
      expect do
        described_class.new.create_auction(auction_params)
      end.to change(Auction, :count).by(1)
    end

    it "creates auction consignment configs" do
      expect do
        described_class.new.create_auction(auction_params)
      end.to change(Auctions::ConsignmentConfig, :count).by(5)
    end

    it "returns auction without errors" do
      result = described_class.new.create_auction(auction_params)
      expect(result.auction.errors).to be_empty
      expect(result.auction.persisted?).to be true
    end
  end

  private

  def auction_params
    {
      start_time: Date.current.beginning_of_day + 15.days,
      end_time: Date.current.end_of_day + 25.days,
      hours_until_sold: 24,
      outside_horses_allowed: true,
      racehorse_allowed_2yo: true,
      racehorse_allowed_3yo: true,
      racehorse_allowed_older: true,
      broodmare_allowed: true,
      stallion_allowed: true,
      yearling_allowed: true,
      weanling_allowed: true,
      reserve_pricing_allowed: false,
      auctioneer: final_furlong,
      title: "Random FF Auction"
    }
  end

  def final_furlong
    name = "Final Furlong"
    @final_furlong ||= Account::Stable.find_by(name:) || create(:stable, name:)
  end

  def other_stable
    name = "My Stable"
    @other_stable ||= Account::Stable.find_by(name:) || create(:stable, name:)
  end
end

