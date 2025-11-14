RSpec.describe Daily::DeleteEmptyAuctionsJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses low_priority queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue("low_priority")
    end

    context "when no auctions start tomorrow" do
      it "does not trigger service" do
        create(:auction, start_time: 10.days.from_now)
        allow(Auctions::DeleteEmptyAuctionService).to receive(:call)
        described_class.perform_later
        expect(Auctions::DeleteEmptyAuctionService).not_to have_received(:call)
      end
    end

    # rubocop:disable Rails/SkipsModelValidations
    context "when auctions start tomorrow" do # rubocop:disable Rails/SkipsModelValidations
      it "triggers service for each auction" do
        auction1 = create(:auction, created_at: 5.days.ago)
        auction1.update_column(:start_time, Date.tomorrow.beginning_of_day)
        auction2 = create(:auction, created_at: 4.days.ago)
        auction2.update_column(:start_time, Date.tomorrow.end_of_day - 1.minute)
        allow(Auctions::DeleteEmptyAuctionService).to receive(:call)
        described_class.perform_later
        expect(Auctions::DeleteEmptyAuctionService).to have_received(:call).with(auction: auction1)
        expect(Auctions::DeleteEmptyAuctionService).to have_received(:call).with(auction: auction2)
      end
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end

