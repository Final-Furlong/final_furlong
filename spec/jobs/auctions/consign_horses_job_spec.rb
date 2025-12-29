RSpec.describe Auctions::ConsignHorsesJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses low_priority queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later(auction: nil)
      end.to have_enqueued_job.on_queue("low_priority")
    end

    context "when auctioneer is Final Furlong" do
      it "triggers consignment service" do
        auction = create(:auction, auctioneer: final_furlong)
        allow(Auctions::HorseConsigner).to receive(:new).and_return mock_service
        described_class.perform_later(auction:)
        expect(mock_service).to have_received(:consign_horses).with(auction:)
      end
    end

    context "when auctioneer is not Final Furlong" do
      it "does not trigger consignment service" do
        auction = create(:auction)
        allow(Auctions::HorseConsigner).to receive(:new).and_return mock_service
        described_class.perform_later(auction:)
        expect(mock_service).not_to have_received(:consign_horses)
      end
    end
  end

  private

  def mock_service
    @mock_service ||= instance_double(Auctions::HorseConsigner,
      consign_horses:
        Auctions::HorseConsigner::Result.new(created: true, auction: create(:auction), number_consigned: 10))
  end

  def final_furlong
    name = "Final Furlong"
    @final_furlong ||= Account::Stable.find_by(name:) || create(:stable, name:)
  end
end

