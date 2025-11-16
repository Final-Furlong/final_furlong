RSpec.describe Auctions::DeleteEmptyAuctionService do
  context "when auction is blank" do
    it "does nothing" do
      expect(described_class.call(auction: nil)).to be_nil
    end
  end

  context "when auction is not blank" do
    context "when auction has 5 horses" do
      before do
        horses = create_list(:auction_horse, 5, auction:)
        horses.each do |horse|
          create(:auction_bid, auction:, horse:)
        end
      end

      it "does not delete auction" do
        expect { described_class.call(auction:) }.not_to change(Auction, :count)
      end

      it "does not delete auction horses" do
        expect { described_class.call(auction:) }.not_to change(Auctions::Horse, :count)
      end

      it "does not delete auction bids" do
        expect { described_class.call(auction:) }.not_to change(Auctions::Bid, :count)
      end
    end

    context "when auction starts after tomorrow" do
      before do
        auction.update_column(:start_time, DateTime.current + 2.days)
        horses = create_list(:auction_horse, 1, auction:)
        horses.each do |horse|
          create(:auction_bid, auction:, horse:)
        end
      end

      it "does not delete auction" do
        expect { described_class.call(auction:) }.not_to change(Auction, :count)
      end

      it "does not delete auction horses" do
        expect { described_class.call(auction:) }.not_to change(Auctions::Horse, :count)
      end

      it "does not delete auction bids" do
        expect { described_class.call(auction:) }.not_to change(Auctions::Bid, :count)
      end
    end

    context "when auction has already started" do
      before do
        auction.update_column(:start_time, DateTime.current - 1.day)
        horses = create_list(:auction_horse, 1, auction:)
        horses.each do |horse|
          create(:auction_bid, auction:, horse:)
        end
      end

      it "does not delete auction" do
        expect { described_class.call(auction:) }.not_to change(Auction, :count)
      end

      it "does not delete auction horses" do
        expect { described_class.call(auction:) }.not_to change(Auctions::Horse, :count)
      end

      it "does not delete auction bids" do
        expect { described_class.call(auction:) }.not_to change(Auctions::Bid, :count)
      end
    end

    context "when auction has less than 5 horses" do
      context "when auctioneer is FF" do
        before do
          auction.auctioneer.update(name: Account::Stable::FINAL_FURLONG)
          horses = create_list(:auction_horse, 1, auction:)
          horses.each do |horse|
            create(:auction_bid, auction:, horse:)
          end
        end

        it "does not delete auction" do
          expect { described_class.call(auction:) }.not_to change(Auction, :count)
        end

        it "does not delete auction horses" do
          expect { described_class.call(auction:) }.not_to change(Auctions::Horse, :count)
        end

        it "does not delete auction bids" do
          expect { described_class.call(auction:) }.not_to change(Auctions::Bid, :count)
        end
      end

      context "when auctioneer is not FF" do
        before do
          auction.auctioneer.update(name: "Random Stable")
          horses = create_list(:auction_horse, 1, auction:)
          horses.each do |horse|
            create(:auction_bid, auction:, horse:)
          end
        end

        it "deletes auction" do
          expect { described_class.call(auction:) }.to change(Auction, :count).by(-1)
        end

        it "deletes auction horses" do
          expect { described_class.call(auction:) }.to change(Auctions::Horse, :count).by(-1)
        end

        it "deletes auction bids" do
          expect { described_class.call(auction:) }.to change(Auctions::Bid, :count).by(-1)
        end
      end
    end
  end

  private

  def auction
    return @auction if @auction

    @auction = create(:auction)
    @auction.update_column(:start_time, DateTime.current + 1.day)
    @auction
  end
end

