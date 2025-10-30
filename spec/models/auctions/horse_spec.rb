RSpec.describe Auctions::Horse do
  describe "associations" do
    it { is_expected.to belong_to(:auction).class_name("::Auction") }
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
    it { is_expected.to have_many(:bids).class_name("Auctions::Bid").dependent(:destroy) }
  end

  describe "validations" do
    describe "max price" do
      it "can be blank" do
        horse = create(:auction_horse)
        expect(horse).to be_valid
      end

      it "cannot be less than reserve price, if there is one" do
        horse = create(:auction_horse)
        horse.reserve_price = 10
        horse.maximum_price = 9
        expect(horse).not_to be_valid
      end

      it "can be equal to reserve price, if there is one" do
        horse = create(:auction_horse)
        horse.reserve_price = 10
        horse.maximum_price = 10
        expect(horse).to be_valid
      end

      it "can be greater than reserve price, if there is one" do
        horse = create(:auction_horse)
        horse.reserve_price = 10
        horse.maximum_price = 12
        expect(horse).to be_valid
      end
    end
  end

  describe "#sold?" do
    context "when sold_at is present" do
      it "returns true" do
        horse = build_stubbed(:auction_horse, sold_at: 1.day.ago)
        expect(horse.sold?).to be true
      end
    end

    context "when sold_at is blank" do
      it "returns false" do
        horse = build_stubbed(:auction_horse, sold_at: nil)
        expect(horse.sold?).to be false
      end
    end
  end
end

