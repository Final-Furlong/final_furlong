RSpec.describe Horses::UpdateHorseAttributesJob, :perform_enqueueed_jobs do
  it "uses default queue", perform_enqueueed_jobs: false do
    expect do
      described_class.perform_later(horse)
    end.to have_enqueued_job.on_queue("default")
  end

  it "triggers lifetime race record view refresh" do
    Racing::LifetimeRaceRecord.refresh
    allow(Racing::LifetimeRaceRecord).to receive(:refresh)
    described_class.perform_later(horse)
    expect(Racing::LifetimeRaceRecord).to have_received(:refresh)
  end

  it "triggers update service" do
    mock_service = instance_double(Horses::UpdateHorseAttributesService, call: true)
    allow(Horses::UpdateHorseAttributesService).to receive(:new).and_return mock_service
    described_class.perform_later(horse)
    expect(mock_service).to have_received(:call).with(horse:)
  end

  private

  def horse
    @horse ||= create(:horse, :racehorse)
  end
end

