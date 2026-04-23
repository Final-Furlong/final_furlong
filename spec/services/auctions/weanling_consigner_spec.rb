RSpec.describe Auctions::WeanlingConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:horse, :weanling, :final_furlong)
      create_views
      expect(described_class.new.select_horses(number: 0).count).to eq 0
    end
  end

  context "when stakes quality is false" do
    it "only returns foals of non-stakes mares" do # rubocop:disable RSpec/ExampleLength
      pending("figure this out")
      created = create(:horse, :weanling, :final_furlong, dam: nil)
      unranked_dam = create(:horse, :broodmare, :final_furlong)
      create(:broodmare_foal_record, mare: unranked_dam)
      unranked = create(:horse, :weanling, :final_furlong, dam: unranked_dam)
      non_stakes_dam = create(:horse, :broodmare, :final_furlong)
      create(:race_result_horse, horse: non_stakes_dam, finish_position: 1, race: create(:race_result, race_type: "maiden"))
      non_stakes = create(:horse, :weanling, :final_furlong, dam: non_stakes_dam)
      stakes_dam = create(:horse, :broodmare, :final_furlong)
      create(:race_result_horse, horse: stakes_dam, finish_position: 1, race: create(:race_result, race_type: "stakes"))
      stakes = create(:horse, :weanling, :final_furlong, dam: stakes_dam)
      create_views

      result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0, stakes_quality: false)
      expect(result).to include unranked, non_stakes, created
      expect(result).not_to include stakes
    end
  end

  context "when stakes quality is true" do
    it "only returns silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      created = create(:horse, :weanling, :final_furlong, dam: nil)
      unranked_dam = create(:horse, :broodmare, :final_furlong)
      unranked = create(:horse, :weanling, :final_furlong, dam: unranked_dam)
      non_stakes_dam = create(:horse, :broodmare, :final_furlong)
      non_stakes = create(:horse, :weanling, :final_furlong, dam: non_stakes_dam)
      stakes_dam = create(:horse, :broodmare, :final_furlong)
      stakes = create(:horse, :weanling, :final_furlong, dam: stakes_dam)
      create(:race_result_horse, horse: non_stakes_dam, finish_position: 1, race: create(:race_result, race_type: "maiden"))
      create(:race_result_horse, horse: stakes_dam, finish_position: 1, race: create(:race_result, race_type: "stakes"))
      create_views

      result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0, stakes_quality: true)
      expect(result).to include stakes
      expect(result).not_to include unranked, non_stakes, created
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:horse, :weanling)
    ff = create(:horse, :weanling, :final_furlong)
    create_views

    result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  it "ignores already consigned horses" do
    already_consigned = create(:horse, :weanling, :final_furlong)
    create(:auction_horse, horse: already_consigned)
    ff = create(:horse, :weanling, :final_furlong)
    ff2 = create(:horse, :weanling, :final_furlong)
    create_views

    result = described_class.new.select_horses(number: 2, min_age: 0, max_age: 0)
    expect(result.size).to eq 2
    expect(result).to include ff, ff2
    expect(result).not_to include already_consigned
  end

  def create_views
    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
  end
end

