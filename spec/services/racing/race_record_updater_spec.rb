RSpec.describe Racing::RaceRecordUpdater do
  it "triggers race record update" do
    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
    allow(Racing::RaceRecord).to receive(:refresh)

    described_class.new.update_records(date:)

    expect(Racing::RaceRecord).to have_received(:refresh)
  end

  it "triggers annual race record update" do
    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
    allow(Racing::AnnualRaceRecord).to receive(:refresh)

    described_class.new.update_records(date:)

    expect(Racing::AnnualRaceRecord).to have_received(:refresh)
  end

  it "triggers lifetime race record update" do
    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
    allow(Racing::LifetimeRaceRecord).to receive(:refresh)

    described_class.new.update_records(date:)

    expect(Racing::LifetimeRaceRecord).to have_received(:refresh)
  end

  it "triggers broodmare record update" do
    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
    allow(Horses::BroodmareFoalRecord).to receive(:refresh)

    described_class.new.update_records(date:)

    expect(Horses::BroodmareFoalRecord).to have_received(:refresh)
  end

  it "triggers stud record update" do
    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
    allow(Horses::StudFoalRecord).to receive(:refresh)

    described_class.new.update_records(date:)

    expect(Horses::StudFoalRecord).to have_received(:refresh)
  end

  private

  def date
    @date ||= Date.current
  end

  def race_result
    @race_result ||= create(:race_result, date:)
  end

  def horse1
    @horse1 ||= create(:horse)
  end

  def horse2
    @horse2 ||= create(:horse)
  end

  def horse3
    @horse3 ||= create(:horse)
  end
end

