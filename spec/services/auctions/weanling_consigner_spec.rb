RSpec.describe Auctions::WeanlingConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:legacy_horse, :weanling, :final_furlong)
      expect(described_class.new.select_horses(number: 0).count).to eq 0
    end
  end

  context "when stakes quality is false" do
    it "only returns foals of non-stakes mares" do # rubocop:disable RSpec/ExampleLength
      created = create(:legacy_horse, :weanling, :final_furlong, Dam: nil)
      unranked_dam = create(:legacy_horse, :broodmare, :final_furlong)
      unranked = create(:legacy_horse, :weanling, :final_furlong, Dam: unranked_dam.ID)
      non_stakes_dam = create(:legacy_horse, :broodmare, :final_furlong)
      create(:legacy_race_record, :winner, Horse: non_stakes_dam.ID)
      non_stakes = create(:legacy_horse, :weanling, :final_furlong, Dam: non_stakes_dam.ID)
      stakes_dam = create(:legacy_horse, :broodmare, :final_furlong)
      create(:legacy_race_record, :stakes_placed, Horse: stakes_dam.ID)
      stakes = create(:legacy_horse, :weanling, :final_furlong, Dam: stakes_dam.ID)

      result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0, stakes_quality: false)
      expect(result).to include unranked, non_stakes, created
      expect(result).not_to include stakes
    end
  end

  context "when stakes quality is true" do
    it "only returns silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      created = create(:legacy_horse, :weanling, :final_furlong, Dam: nil)
      unranked_dam = create(:legacy_horse, :broodmare, :final_furlong)
      unranked = create(:legacy_horse, :weanling, :final_furlong, Dam: unranked_dam.ID)
      non_stakes_dam = create(:legacy_horse, :broodmare, :final_furlong)
      non_stakes = create(:legacy_horse, :weanling, :final_furlong, Dam: non_stakes_dam.ID)
      stakes_dam = create(:legacy_horse, :broodmare, :final_furlong)
      stakes = create(:legacy_horse, :weanling, :final_furlong, Dam: stakes_dam.ID)
      create(:legacy_race_record, :winner, Horse: non_stakes_dam.ID)
      create(:legacy_race_record, :stakes_placed, Horse: stakes_dam.ID)

      result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0, stakes_quality: true)
      expect(result).to include stakes
      expect(result).not_to include unranked, non_stakes, created
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:legacy_horse, :weanling, Owner: 35)
    ff = create(:legacy_horse, :weanling, :final_furlong)

    result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  it "ignores already consigned horses" do
    already_consigned_1 = create(:legacy_horse, :weanling, :final_furlong)
    already_con_1_horse = create(:horse, :weanling, legacy_id: already_consigned_1.ID)
    create(:auction_horse, horse: already_con_1_horse)
    ff = create(:legacy_horse, :weanling, :final_furlong)
    ff2 = create(:legacy_horse, :weanling, :final_furlong)

    result = described_class.new.select_horses(number: 2, min_age: 0, max_age: 0)
    expect(result.size).to eq 2
    expect(result).to include ff, ff2
    expect(result).not_to include already_con_1_horse
  end
end

