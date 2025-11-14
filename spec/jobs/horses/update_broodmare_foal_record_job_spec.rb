RSpec.describe Horses::UpdateBroodmareFoalRecordJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses default queue", perform_enqueueed_jobs: false do
      expect do
        described_class.perform_later(horse)
      end.to have_enqueued_job.on_queue("default")
    end

    it "triggers service" do
      mock_creator = instance_double(Horses::BroodmareFoalRecordCreator, create_record: true)
      allow(Horses::BroodmareFoalRecordCreator).to receive(:new).and_return mock_creator
      described_class.perform_later(horse)
      expect(mock_creator).to have_received(:create_record).with(horse:)
    end
  end

  private

  def horse
    @horse ||= create(:horse, :broodmare)
  end
end

