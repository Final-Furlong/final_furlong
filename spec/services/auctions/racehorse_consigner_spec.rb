RSpec.describe Auctions::RacehorseConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:legacy_horse, :racehorse, :final_furlong)
      expect(described_class.new.select_horses(number: 0, min_age: 2, max_age: 4).count).to eq 0
    end
  end

  context "when min age = max age" do
    it "only returns horses of that age" do
      two_yo = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 2.years)
      three_yo = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 1.year)

      result = described_class.new.select_horses(number: 10, min_age: 2, max_age: 2)
      expect(result).to include two_yo
      expect(result).not_to include three_yo
    end
  end

  context "when stakes quality is false" do
    it "only returns non-stakes horses" do
      unraced = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 2.years)
      non_stakes = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 2.years)
      stakes = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 1.year)
      create(:legacy_race_record, :winner, Horse: non_stakes.ID)
      create(:legacy_race_record, :stakes_placed, Horse: stakes.ID)

      result = described_class.new.select_horses(number: 10, min_age: 2, max_age: 6, stakes_quality: false)
      expect(result).to include non_stakes, unraced
      expect(result).not_to include stakes
    end
  end

  context "when stakes quality is true" do
    it "only returns stakes horses" do
      non_stakes = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 2.years)
      stakes = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 1.year)
      stakes2 = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 1.year)
      create(:legacy_race_record, :winner, Horse: non_stakes.ID)
      create(:legacy_race_record, :stakes_placed, Horse: stakes.ID)
      create(:legacy_race_record, :stakes_winner, Horse: stakes2.ID)

      result = described_class.new.select_horses(number: 10, min_age: 2, max_age: 6, stakes_quality: true)
      expect(result).to include stakes, stakes2
      expect(result).not_to include non_stakes
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:legacy_horse, :racehorse, DOB: Date.current + 2.years, Owner: 35)
    ff = create(:legacy_horse, :racehorse, :final_furlong, DOB: Date.current + 1.year)

    result = described_class.new.select_horses(number: 10, min_age: 2, max_age: 6)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  it "ignores already consigned horses" do
    Legacy::Horse.destroy_all
    already_consigned_1 = create(:legacy_horse, :racehorse, :final_furlong)
    already_con_1_horse = create(:horse, :racehorse, legacy_id: already_consigned_1.ID)
    create(:auction_horse, horse: already_con_1_horse)
    ff = create(:legacy_horse, :racehorse, :final_furlong)
    ff2 = create(:legacy_horse, :racehorse, :final_furlong)

    result = described_class.new.select_horses(number: 2, min_age: 2, max_age: 5)
    expect(result.size).to eq 2
    expect(result).to include ff, ff2
    expect(result).not_to include already_con_1_horse
  end
end

