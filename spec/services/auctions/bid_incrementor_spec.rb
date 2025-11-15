RSpec.describe Auctions::BidIncrementor do
  context "when new current bid is not higher than previous maximum bid" do
    it "returns created true" do
      result = described_class.new.increment_bid(bid_params)
      expect(result.created?).to be true
    end

    it "create bids" do
      bid
      expect do
        described_class.new.increment_bid(bid_params)
      end.to change(Auctions::Bid, :count).by(2)
    end

    it "returns current high bid" do
      result = described_class.new.increment_bid(bid_params)
      new_bid = Auctions::Bid.where.not(id: bid.id).find_by(bidder: bid.bidder)
      expect(result.current_bid).to eq new_bid
    end

    it "sets correct attributes for new bid for high bidder" do
      freeze_time
      described_class.new.increment_bid(bid_params)
      new_bid = Auctions::Bid.where.not(id: bid.id).find_by(bidder: bid.bidder)
      expect(new_bid).to have_attributes(
        current_bid: 5000,
        maximum_bid: 5000,
        bidder: bid.bidder,
        created_at: Time.current,
        updated_at: Time.current
      )
    end

    it "sets correct attributes for new bid for under-bidder" do
      freeze_time
      described_class.new.increment_bid(bid_params)
      new_bid = Auctions::Bid.where.not(bidder: bid.bidder).find_by(horse: bid.horse)
      expect(new_bid).to have_attributes(
        current_bid: 4500,
        maximum_bid: 4500,
        bidder: stable,
        created_at: 1.second.ago,
        updated_at: 1.second.ago
      )
    end
  end

  context "when new current bid is equal to previous maximum bid" do
    it "returns created false" do
      result = described_class.new.increment_bid(bid_params.merge(current_bid: 5000))
      expect(result.created?).to be true
    end

    it "returns current high bid" do
      result = described_class.new.increment_bid(bid_params.merge(current_bid: 5000))
      new_bid = Auctions::Bid.where.not(id: bid.id).find_by(bidder: bid.bidder)
      expect(result.current_bid).to eq new_bid
    end

    it "creates bids" do
      bid
      expect do
        described_class.new.increment_bid(bid_params.merge(current_bid: 5000))
      end.to change(Auctions::Bid, :count).by(2)
    end

    it "sets correct attributes for new bid for high bidder" do
      freeze_time
      described_class.new.increment_bid(bid_params.merge(current_bid: 5000))
      new_bid = Auctions::Bid.where.not(id: bid.id).find_by(bidder: bid.bidder)
      expect(new_bid).to have_attributes(
        current_bid: 5000,
        maximum_bid: 5000,
        bidder: bid.bidder,
        created_at: Time.current,
        updated_at: Time.current
      )
    end

    it "sets correct attributes for new bid for under-bidder" do
      freeze_time
      described_class.new.increment_bid(bid_params.merge(current_bid: 5000))
      new_bid = Auctions::Bid.where.not(bidder: bid.bidder).find_by(horse: bid.horse)
      expect(new_bid).to have_attributes(
        current_bid: 5000,
        maximum_bid: nil,
        bidder: stable,
        created_at: 1.second.ago,
        updated_at: 1.second.ago
      )
    end
  end

  context "when new maximum bid is equal to previous maximum bid" do
    it "returns created false" do
      result = described_class.new.increment_bid(bid_params.merge(current_bid: 5000, maximum_bid: 5000))
      expect(result.created?).to be true
    end

    it "creates bids" do
      bid
      expect do
        described_class.new.increment_bid(bid_params.merge(current_bid: 5000))
      end.to change(Auctions::Bid, :count).by(2)
    end

    it "sets correct attributes for new bid for high bidder" do
      freeze_time
      described_class.new.increment_bid(bid_params.merge(current_bid: 5000))
      new_bid = Auctions::Bid.where.not(id: bid.id).find_by(bidder: bid.bidder)
      expect(new_bid).to have_attributes(
        current_bid: 5000,
        maximum_bid: 5000,
        bidder: bid.bidder,
        created_at: Time.current,
        updated_at: Time.current
      )
    end

    it "sets correct attributes for new bid for under-bidder" do
      freeze_time
      described_class.new.increment_bid(bid_params.merge(current_bid: 5000))
      new_bid = Auctions::Bid.where.not(bidder: bid.bidder).find_by(horse: bid.horse)
      expect(new_bid).to have_attributes(
        current_bid: 5000,
        maximum_bid: nil,
        bidder: stable,
        created_at: 1.second.ago,
        updated_at: 1.second.ago
      )
    end
  end

  context "when new maximum bid is well under to previous maximum bid" do
    before { bid.update(maximum_bid: 10_000) }

    it "returns created false" do
      result = described_class.new.increment_bid(bid_params.merge(current_bid: 5000, maximum_bid: 7000))
      expect(result.created?).to be true
    end

    it "creates bids" do
      bid
      expect do
        described_class.new.increment_bid(bid_params.merge(current_bid: 5000, maximum_bid: 7000))
      end.to change(Auctions::Bid, :count).by(2)
    end

    it "sets correct attributes for new bid for high bidder" do
      freeze_time
      described_class.new.increment_bid(bid_params.merge(current_bid: 5000, maximum_bid: 7000))
      new_bid = Auctions::Bid.where.not(id: bid.id).find_by(bidder: bid.bidder)
      expect(new_bid).to have_attributes(
        current_bid: 7500,
        maximum_bid: 10_000,
        bidder: bid.bidder,
        created_at: Time.current,
        updated_at: Time.current
      )
    end

    it "sets correct attributes for new bid for under-bidder" do
      freeze_time
      described_class.new.increment_bid(bid_params.merge(current_bid: 5000, maximum_bid: 7000))
      new_bid = Auctions::Bid.where.not(bidder: bid.bidder).find_by(horse: bid.horse)
      expect(new_bid).to have_attributes(
        current_bid: 7000,
        maximum_bid: 7000,
        bidder: stable,
        created_at: 1.second.ago,
        updated_at: 1.second.ago
      )
    end
  end

  context "when new bidder is equal to current bidder" do
    it "returns created false" do
      bid.update(bidder: stable)
      result = described_class.new.increment_bid(bid_params)
      expect(result.created?).to be false
    end

    it "does not create bids" do
      bid.update(bidder: stable)
      expect do
        described_class.new.increment_bid(bid_params)
      end.not_to change(Auctions::Bid, :count)
    end

    it "does not return current high bid" do
      bid.update(bidder: stable)
      result = described_class.new.increment_bid(bid_params)
      expect(result.current_bid).to be_nil
    end
  end

  context "when bid creation fails" do
    before { allow(Auctions::Bid).to receive(:create!).and_raise ActiveRecord::RecordInvalid }

    it "returns created false" do
      result = described_class.new.increment_bid(bid_params)
      expect(result.created?).to be false
    end

    it "does not create bids" do
      bid
      expect do
        described_class.new.increment_bid(bid_params)
      end.not_to change(Auctions::Bid, :count)
    end

    it "does not return current high bid" do
      result = described_class.new.increment_bid(bid_params)
      expect(result.current_bid).to be_nil
    end
  end

  private

  def bid_params
    {
      original_bid_id: bid.id,
      new_bidder_id: stable.id,
      current_bid: 3500,
      maximum_bid: 4500
    }
  end

  def bid
    @bid ||= create(:auction_bid, horse:, current_bid: 3000, maximum_bid: 5000)
  end

  def stable
    @stable ||= create(:stable)
  end

  def horse
    @horse ||= create(:auction_horse)
  end
end

