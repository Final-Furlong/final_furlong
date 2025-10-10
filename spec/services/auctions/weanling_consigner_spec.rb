RSpec.describe Auctions::WeanlingConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:legacy_horse, :weanling, :final_furlong, :sellable)
      expect(described_class.new.select_horses(number: 0).count).to eq 0
    end
  end

  context "when stakes quality is false" do
    it "only returns foals of non-stakes mares" do # rubocop:disable RSpec/ExampleLength
      created = create(:legacy_horse, :weanling, :final_furlong, :sellable, Dam: nil)
      unranked_dam = create(:legacy_horse, :broodmare, :final_furlong)
      unranked = create(:legacy_horse, :weanling, :final_furlong, :sellable, Dam: unranked_dam.ID)
      non_stakes_dam = create(:legacy_horse, :broodmare, :final_furlong)
      create(:legacy_race_record, :winner, Horse: non_stakes_dam.ID)
      non_stakes = create(:legacy_horse, :weanling, :final_furlong, :sellable, Dam: non_stakes_dam.ID)
      stakes_dam = create(:legacy_horse, :broodmare, :final_furlong)
      create(:legacy_race_record, :stakes_placed, Horse: stakes_dam.ID)
      stakes = create(:legacy_horse, :weanling, :final_furlong, :sellable, Dam: stakes_dam.ID)

      result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0, stakes_quality: false)
      expect(result).to include unranked, non_stakes, created
      expect(result).not_to include stakes
    end
  end

  context "when stakes quality is true" do
    it "only returns silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      created = create(:legacy_horse, :weanling, :final_furlong, :sellable, Dam: nil)
      unranked_dam = create(:legacy_horse, :broodmare, :final_furlong)
      unranked = create(:legacy_horse, :weanling, :final_furlong, :sellable, Dam: unranked_dam.ID)
      non_stakes_dam = create(:legacy_horse, :broodmare, :final_furlong)
      non_stakes = create(:legacy_horse, :weanling, :final_furlong, :sellable, Dam: non_stakes_dam.ID)
      stakes_dam = create(:legacy_horse, :broodmare, :final_furlong)
      stakes = create(:legacy_horse, :weanling, :final_furlong, :sellable, Dam: stakes_dam.ID)
      create(:legacy_race_record, :winner, Horse: non_stakes_dam.ID)
      create(:legacy_race_record, :stakes_placed, Horse: stakes_dam.ID)

      result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0, stakes_quality: true)
      expect(result).to include stakes
      expect(result).not_to include unranked, non_stakes, created
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:legacy_horse, :weanling, :sellable, Owner: 35)
    ff = create(:legacy_horse, :weanling, :final_furlong, :sellable)

    result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  it "only returns horses that are sellable" do
    sellable = create(:legacy_horse, :weanling, :final_furlong, :sellable)
    non_sellable = create(:legacy_horse, :weanling, :final_furlong)

    result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0)
    expect(result).to include sellable
    expect(result).not_to include non_sellable
  end
end

