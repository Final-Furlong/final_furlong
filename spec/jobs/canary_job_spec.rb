RSpec.describe CanaryJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses default queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later
      end.to have_enqueued_job.on_queue("default")
    end

    it "writes timestamp to cache" do
      expect(Rails.cache.fetch("canary_last_run")).to be_nil
      freeze_time do
        described_class.perform_later
        expect(Rails.cache.read("canary_last_run")).to eq Time.current
      end
    end
  end
end

