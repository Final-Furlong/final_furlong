RSpec.describe Horses::UpdateStudFoalRecordJob, :perform_enqueued_jobs do
  describe "#perform" do
    it "uses default queue", perform_enqueueed_jobs: false do
      Horses::Horse.destroy_all
      horse
      expect do
        described_class.perform_later(horse)
      end.to have_enqueued_job.on_queue("default")
    end

    it "triggers service" do
      mock_creator = instance_double(Horses::StudFoalRecordCreator, create_record: true)
      allow(Horses::StudFoalRecordCreator).to receive(:new).and_return mock_creator
      described_class.perform_later(horse)
      expect(mock_creator).to have_received(:create_record).with(horse:)
    end
  end

  private

  def horse
    @horse ||= create(:horse, :stallion)
  end
end

