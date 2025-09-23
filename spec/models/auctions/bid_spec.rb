RSpec.describe Auctions::Bid do
  describe "associations" do
    it { is_expected.to belong_to(:auction).class_name("::Auction") }
    it { is_expected.to belong_to(:horse).class_name("Auctions::Horse") }
    it { is_expected.to belong_to(:bidder).class_name("Account::Stable") }
  end

  describe "validations" do
    describe "maximum bid" do
      it "can be blank" do
        bid = create(:auction_bid)
        expect(bid).to be_valid
      end

      it "cannot be less than current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 10
        bid.maximum_bid = 9
        expect(bid).not_to be_valid
      end

      it "can be equal to current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 10
        bid.maximum_bid = 10
        expect(bid).to be_valid
      end

      it "can be greater than current bid" do
        bid = create(:auction_bid)
        bid.current_bid = 10
        bid.maximum_bid = 12
        expect(bid).to be_valid
      end
    end
  end
end

