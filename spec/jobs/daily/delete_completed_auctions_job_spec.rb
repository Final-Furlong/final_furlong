RSpec.describe Daily::DeleteCompletedAuctionsJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses low_priority queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later(auction: nil)
      end.to have_enqueued_job.on_queue("low_priority")
    end

    # rubocop:disable Rails/SkipsModelValidations
    context "when no auctions have ended" do
      it "does not trigger service" do
        auction = create(:auction)
        auction.update_column(:end_time, 10.minutes.from_now)
        allow(Auctions::DeleteCompletedAuctionService).to receive(:call)
        described_class.perform_later(auction:)
        expect(Auctions::DeleteCompletedAuctionService).not_to have_received(:call)
      end
    end

    context "when auctions have ended" do
      it "triggers service for each auction" do
        auction = create(:auction)
        auction.update_column(:end_time, 1.day.ago)
        allow(Auctions::DeleteCompletedAuctionService).to receive(:call)
        described_class.perform_later(auction:)
        expect(Auctions::DeleteCompletedAuctionService).to have_received(:call).with(auction:)
      end
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end

