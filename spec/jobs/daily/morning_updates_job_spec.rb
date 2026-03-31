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

    it "stores job result" do
      expect { described_class.perform_later }.to change(JobStat, :count).by(11)
      expect(JobStat.find_by(name: described_class.name)).to have_attributes(
                                                               outcome: { classes: described_class.new.class_list.count }.stringify_keys
                                                             )
    end
  end
end

