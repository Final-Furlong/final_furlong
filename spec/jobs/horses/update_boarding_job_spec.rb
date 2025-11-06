RSpec.describe Horses::UpdateBoardingJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses default queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue("default")
    end

    it "triggers service for each auction" do
      mock_updator = instance_double(Horses::AutoBoardingUpdator, call: true)
      allow(Horses::AutoBoardingUpdator).to receive(:new).and_return mock_updator
      described_class.perform_later
      expect(mock_updator).to have_received(:call)
    end
  end
end

