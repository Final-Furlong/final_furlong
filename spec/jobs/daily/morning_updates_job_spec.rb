RSpec.describe Daily::MorningUpdatesJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses low_priority queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue("default")
    end

    it "triggers boarding job" do
      allow(Horses::UpdateBoardingJob).to receive(:perform_later)
      described_class.perform_later
      expect(Horses::UpdateBoardingJob).to have_received(:perform_later)
    end

    it "triggers leases job" do
      allow(Horses::UpdateLeasesJob).to receive(:perform_later)
      described_class.perform_later
      expect(Horses::UpdateLeasesJob).to have_received(:perform_later)
    end

    it "triggers sales job" do
      allow(Horses::UpdateSalesJob).to receive(:perform_later)
      described_class.perform_later
      expect(Horses::UpdateSalesJob).to have_received(:perform_later)
    end

    it "triggers activations job" do
      allow(Daily::CreateActivationsJob).to receive(:perform_later)
      described_class.perform_later
      expect(Daily::CreateActivationsJob).to have_received(:perform_later)
    end

    it "triggers naming job" do
      allow(Horses::NameHorsesJob).to receive(:perform_later)
      described_class.perform_later
      expect(Horses::NameHorsesJob).to have_received(:perform_later)
    end

    it "triggers babies job" do
      allow(Horses::UpdateBabiesJob).to receive(:perform_later)
      described_class.perform_later
      expect(Horses::UpdateBabiesJob).to have_received(:perform_later)
    end

    it "triggers mare status jobs" do
      allow(Horses::RetireMaresJob).to receive(:perform_later)
      allow(Horses::KillMaresJob).to receive(:perform_later)
      described_class.perform_later
      expect(Horses::RetireMaresJob).to have_received(:perform_later)
      expect(Horses::KillMaresJob).to have_received(:perform_later)
    end

    it "triggers notifications job" do
      allow(Daily::DeleteReadNotificationsJob).to receive(:perform_later)
      described_class.perform_later
      expect(Daily::DeleteReadNotificationsJob).to have_received(:perform_later)
    end

    it "triggers rest days job" do
      allow(Racing::RestDayUpdaterJob).to receive(:perform_later)
      described_class.perform_later
      expect(Racing::RestDayUpdaterJob).to have_received(:perform_later)
    end

    it "triggers future shipments job" do
      allow(Daily::ProcessFutureShipmentsJob).to receive(:perform_later)
      described_class.perform_later
      expect(Daily::ProcessFutureShipmentsJob).to have_received(:perform_later)
    end

    it "stores job result" do
      count = described_class.new.class_list.count
      expect { described_class.perform_later }.to change(JobStat, :count).by(count + 1)
      expect(JobStat.find_by(name: described_class.name)).to have_attributes(outcome: { classes: count }.stringify_keys)
    end
  end
end

