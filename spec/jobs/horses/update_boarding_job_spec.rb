RSpec.describe Horses::UpdateBoardingJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses default queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue("default")
    end

    it "triggers service" do
      mock_updater = instance_double(Horses::AutoBoardingUpdater, call: true)
      allow(Horses::AutoBoardingUpdater).to receive(:new).and_return mock_updater
      described_class.perform_later
      expect(mock_updater).to have_received(:call)
    end

    it "stores job result" do
      result = { horses_updated: 11, stables_updated: 3 }
      mock_updater = instance_double(Horses::AutoBoardingUpdater, call: result)
      allow(Horses::AutoBoardingUpdater).to receive(:new).and_return mock_updater
      expect { described_class.perform_later }.to change(JobStat, :count).by(1)
      expect(JobStat.find_by(name: described_class.name)).to have_attributes(
                                                               outcome: result.stringify_keys
                                                             )
    end
  end
end

