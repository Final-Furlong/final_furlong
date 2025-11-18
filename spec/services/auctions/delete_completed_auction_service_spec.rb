RSpec.describe Auctions::DeleteCompletedAuctionService do
  context "when auction is blank" do
    it "does nothing" do
      expect(described_class.call(auction: nil)).to be_nil
    end
  end

  context "when auction is not blank" do
    before { setup_data }

    context "when auction end time has not been met" do
      before { auction.update_column(:end_time, DateTime.current + 1.hour) }

      it "does not delete auction bids" do
        expect { described_class.call(auction:) }.not_to change(Auctions::Bid, :count)
      end

      it "does not delete auction horses" do
        expect { described_class.call(auction:) }.not_to change(Auctions::Horse, :count)
      end

      it "does not delete auction" do
        expect { described_class.call(auction:) }.not_to change(Auction, :count)
      end
    end

    context "when auction end time has been met" do
      before { auction.update_column(:end_time, DateTime.current - 1.hour) }

      context "when there are unsold horses" do
        before do
          unsold_horse_bid
          allow(Auctions::HorseSeller).to receive(:new).and_return mock_seller
        end

        it "processes sale" do
          described_class.call(auction:)
          expect(mock_seller).to have_received(:process_sale).with(bid: unsold_horse_bid, disable_job_trigger: true)
        end

        it "deletes auction bid" do
          expect { described_class.call(auction:) }.to change(Auctions::Bid, :count).by(-2)
        end

        it "deletes auction horses" do
          expect { described_class.call(auction:) }.to change(Auctions::Horse, :count).by(-2)
        end

        it "deletes auction" do
          expect { described_class.call(auction:) }.to change(Auction, :count).by(-1)
        end
      end

      context "when processing unsold horses fails" do
        before { allow(Auctions::HorseSeller).to receive(:new).and_return mock_seller_failure }

        it "raises error" do
          expect { described_class.call(auction:) }.to raise_error described_class::UnprocessedSaleError, "Could not sell horse #{unsold_horse.id}"
        end

        it "tries to processes sale" do
          expect { described_class.call(auction:) }.to raise_error described_class::UnprocessedSaleError
          expect(mock_seller_failure).to have_received(:process_sale).with(bid: unsold_horse_bid, disable_job_trigger: true)
        end

        it "does not delete auction bid" do
          expect { described_class.call(auction:) }.to raise_error described_class::UnprocessedSaleError
          expect(Auctions::Bid.count).to eq 2
        end

        it "does not delete auction horses" do
          expect { described_class.call(auction:) }.to raise_error described_class::UnprocessedSaleError
          expect(Auctions::Horse.count).to eq 2
        end

        it "does not delete auction" do
          expect { described_class.call(auction:) }.to raise_error described_class::UnprocessedSaleError
          expect(Auction.count).to eq 1
        end
      end
    end
  end

  private

  def mock_seller_failure
    @mock_seller_failure ||= instance_double(Auctions::HorseSeller, process_sale: mock_result_failure)
  end

  def mock_result_failure
    @mock_result_failure ||= instance_double(Auctions::HorseSeller::Result, sold?: false)
  end

  def mock_seller
    @mock_seller ||= instance_double(Auctions::HorseSeller, process_sale: mock_result)
  end

  def mock_result
    @mock_result ||= instance_double(Auctions::HorseSeller::Result, sold?: true)
  end

  def setup_data
    sold_horse
    sold_horse_bid
    unsold_horse
    unsold_horse_bid
  end

  def unsold_horse
    @unsold_horse ||= create(:auction_horse, auction:, sold_at: nil)
  end

  def unsold_horse_bid
    @unsold_horse_bid ||= create(:auction_bid, auction:, horse: unsold_horse,
      updated_at: DateTime.current - 2.hours,
      current_high_bid: true)
  end

  def sold_horse
    @sold_horse ||= create(:auction_horse, auction:, sold_at: DateTime.current - 1.hour)
  end

  def sold_horse_bid
    @sold_horse_bid ||= create(:auction_bid, auction:, horse: sold_horse,
      updated_at: DateTime.current - 12.hours,
      current_high_bid: true)
  end

  def auction
    return @auction if @auction

    @auction = create(:auction)
    @auction.update_column(:end_time, DateTime.current - 1.hour)
    @auction
  end
end

