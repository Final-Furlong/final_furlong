RSpec.describe Racing::RaceRecordUpdater do
  it "triggers view updates" do
    allow(Racing::AnnualRaceRecord).to receive(:refresh)
    allow(Racing::LifetimeRaceRecord).to receive(:refresh)

    described_class.new.update_records(date:)

    expect(Racing::AnnualRaceRecord).to have_received(:refresh)
    expect(Racing::LifetimeRaceRecord).to have_received(:refresh)
  end

  context "when horses have sires" do
    before do
      horse1.update(sire: create(:horse, :stallion))
      horse2.update(sire: create(:horse, :stallion))
      horse3.update(sire: horse1.sire)
      create(:race_result_horse, race: race_result, horse: horse1)
      create(:race_result_horse, race: race_result, horse: horse2)
      create(:race_result_horse, race: race_result, horse: horse3)
    end

    it "triggers broodmare foal record update for each unique sire" do
      described_class.new.update_records(date:)

      expect(Horses::UpdateStudFoalRecordJob).to have_been_enqueued.with(horse1.sire)
      expect(Horses::UpdateStudFoalRecordJob).to have_been_enqueued.with(horse2.sire)
    end
  end

  context "when horses have dams" do
    before do
      horse1.update(dam: create(:horse, :broodmare))
      horse2.update(dam: create(:horse, :broodmare))
      horse3.update(dam: horse1.dam)
      create(:race_result_horse, race: race_result, horse: horse1)
      create(:race_result_horse, race: race_result, horse: horse2)
      create(:race_result_horse, race: race_result, horse: horse3)
    end

    it "triggers broodmare foal record update for each unique dam" do
      described_class.new.update_records(date:)

      expect(Horses::UpdateBroodmareFoalRecordJob).to have_been_enqueued.with(horse1.dam)
      expect(Horses::UpdateBroodmareFoalRecordJob).to have_been_enqueued.with(horse2.dam)
    end
  end

  private

  def date
    @date ||= Date.current
  end

  def race_result
    @race_result ||= create(:race_result, date:)
  end

  def horse1
    @horse1 ||= create(:horse, legacy_id: 10)
  end

  def horse2
    @horse2 ||= create(:horse, legacy_id: 20)
  end

  def horse3
    @horse3 ||= create(:horse, legacy_id: 20)
  end
end

