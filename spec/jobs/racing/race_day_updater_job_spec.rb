RSpec.describe Racing::RaceDayUpdaterJob, :perform_enqueueed_jobs do
  it "uses default queue", perform_enqueueed_jobs: false do
    expect do
      described_class.perform_later(date:)
    end.to have_enqueued_job.on_queue("default")
  end

  it "triggers race record updater service" do
    allow(Racing::RaceRecordUpdater).to receive(:new).and_return mock_service
    described_class.perform_later(date:)
    expect(mock_service).to have_received(:update_records).with(date:)
  end

  private

  def mock_service
    @mock_service ||= instance_double(Racing::RaceRecordUpdater, update_records: true)
  end

  def date
    @date ||= Date.current
  end
end

