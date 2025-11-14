RSpec.describe Auctions::CreateMixedAuctionJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses low_priority queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue("low_priority")
    end

    context "when auction already exists" do
      it "does not create auction" do
        final_furlong
        travel_to Time.zone.local(2025, 6, 1, 0, 0, 0) do
          described_class.perform_later

          expect do
            described_class.perform_later
          end.not_to change(Auction, :count)
        end
      end
    end

    context "when auction does not exist" do
      it "creates auction" do
        final_furlong
        travel_to Time.zone.local(2025, 6, 1, 0, 0, 0) do
          expect do
            described_class.perform_later
          end.to change(Auction, :count).by(1)
        end
      end

      context "when current date is later than June 15" do
        it "does not create auction" do
          final_furlong
          travel_to Time.zone.local(2025, 6, 16, 0, 0, 0) do
            expect do
              described_class.perform_later
            end.not_to change(Auction, :count)
          end
        end
      end

      context "when auction creation fails" do
        it "does not create auction" do
          auction = build_stubbed(:auction, title: nil)
          auction.valid?
          result = instance_double(Auctions::MixedAuctionCreator::Result, created?: false, auction:)
          allow_any_instance_of(Auctions::MixedAuctionCreator).to receive(:create_auction).and_return result # rubocop:disable RSpec/AnyInstance
          final_furlong
          travel_to Time.zone.local(2025, 6, 1, 0, 0, 0) do
            expect do
              described_class.perform_later
            end.to raise_error described_class::AuctionNotCreated, "Title can't be blank and Title is too short (minimum is 10 characters)"
          end
        end
      end
    end
  end

  private

  def final_furlong
    name = "Final Furlong"
    @final_furlong ||= Account::Stable.find_by(name:) || create(:stable, name:)
  end
end

