RSpec.describe Auctions::BidDeleter do
  before { bid }

  context "when other bids exist that are not to be deleted" do
    before { previous_bid }

    it "returns deleted true" do
      result = described_class.new.delete_bids(bids: [bid])
      expect(result.deleted?).to be true
    end

    it "updates data of most recent non-deleted bid" do
      freeze_time
      described_class.new.delete_bids(bids: [bid])
      expect(previous_bid.reload.bid_at).to eq Time.current
      expect(previous_bid.current_high_bid).to be true
    end

    it "does not modify bids earlier than the most recent non-deleted bid" do
      previous_bid_2 = create(:auction_bid, horse:, current_bid: 1000, maximum_bid: 1000, created_at: previous_bid.created_at - 2.hours, updated_at: previous_bid.created_at - 1.hour)
      expect do
        described_class.new.delete_bids(bids: [bid])
      end.not_to change(previous_bid_2, :reload)
    end

    it "deletes bids" do
      expect do
        described_class.new.delete_bids(bids: [bid])
      end.to change(Auctions::Bid, :count).by(-1)
    end
  end

  context "when no other bids exist that are not to be deleted" do
    it "returns deleted true" do
      result = described_class.new.delete_bids(bids: [bid])
      expect(result.deleted?).to be true
    end

    it "removes all bids" do
      described_class.new.delete_bids(bids: [bid])
      expect(Auctions::Bid.exists?(horse: bid.horse)).to be false
    end

    it "deletes bids" do
      expect do
        described_class.new.delete_bids(bids: [bid])
      end.to change(Auctions::Bid, :count).by(-1)
    end
  end

  context "when multiple bids are to be deleted" do
    before { bid2 }

    it "returns deleted true" do
      result = described_class.new.delete_bids(bids: [bid, bid2])
      expect(result.deleted?).to be true
    end

    it "removes all bids" do
      described_class.new.delete_bids(bids: [bid, bid2])
      expect(Auctions::Bid.exists?(horse: bid.horse)).to be false
    end

    it "deletes bids" do
      expect do
        described_class.new.delete_bids(bids: [bid, bid2])
      end.to change(Auctions::Bid, :count).by(-2)
    end
  end

  context "when bid deletion fails" do
    before { allow(bid).to receive(:destroy!).and_raise ActiveRecord::RecordInvalid }

    it "returns deleted false" do
      result = described_class.new.delete_bids(bids: [bid])
      expect(result.deleted?).to be false
    end

    it "does not delete bids" do
      expect do
        described_class.new.delete_bids(bids: [bid])
      end.not_to change(Auctions::Bid, :count)
    end
  end

  private

  def bid
    @bid ||= create(:auction_bid, horse:, current_bid: 3000, maximum_bid: 5000)
  end

  def bid2
    @bid2 ||= create(:auction_bid, horse:, current_bid: 3000, maximum_bid: 5000)
  end

  def previous_bid
    @previous_bid ||= create(:auction_bid, horse:, current_bid: 1000, maximum_bid: 1000, created_at: bid.created_at - 2.hours, updated_at: bid.created_at - 1.hour)
  end

  def horse
    @horse ||= create(:auction_horse)
  end
end

