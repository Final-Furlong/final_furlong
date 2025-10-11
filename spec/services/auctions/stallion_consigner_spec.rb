RSpec.describe Auctions::StallionConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:legacy_horse, :stallion, :final_furlong)
      expect(described_class.new.select_horses(number: 0, min_age: 4, max_age: 10).count).to eq 0
    end
  end

  context "when min age = max age" do
    it "only returns horses of that age" do
      younger = create(:legacy_horse, :stallion, :final_furlong, DOB: Date.current - 2.years)
      older = create(:legacy_horse, :stallion, :final_furlong, DOB: Date.current - 3.years)

      result = described_class.new.select_horses(number: 10, min_age: 6, max_age: 6)
      expect(result).to include younger
      expect(result).not_to include older
    end
  end

  context "when stakes quality is false" do
    it "only returns non-silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      unranked = create(:legacy_horse, :stallion, :final_furlong)
      bronze = create(:legacy_horse, :stallion, :final_furlong)
      silver = create(:legacy_horse, :stallion, :final_furlong)
      gold = create(:legacy_horse, :stallion, :final_furlong)
      platinum = create(:legacy_horse, :stallion, :final_furlong)
      create(:legacy_horse_breed_ranking, :bronze, Horse: bronze.ID)
      create(:legacy_horse_breed_ranking, :silver, Horse: silver.ID)
      create(:legacy_horse_breed_ranking, :gold, Horse: gold.ID)
      create(:legacy_horse_breed_ranking, :platinum, Horse: platinum.ID)

      result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15, stakes_quality: false)
      expect(result).to include unranked, bronze, silver
      expect(result).not_to include gold, platinum
    end
  end

  context "when stakes quality is true" do
    it "only returns silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      unranked = create(:legacy_horse, :stallion, :final_furlong)
      bronze = create(:legacy_horse, :stallion, :final_furlong)
      silver = create(:legacy_horse, :stallion, :final_furlong)
      gold = create(:legacy_horse, :stallion, :final_furlong)
      platinum = create(:legacy_horse, :stallion, :final_furlong)
      create(:legacy_horse_breed_ranking, :bronze, Horse: bronze.ID)
      create(:legacy_horse_breed_ranking, :silver, Horse: silver.ID)
      create(:legacy_horse_breed_ranking, :gold, Horse: gold.ID)
      create(:legacy_horse_breed_ranking, :platinum, Horse: platinum.ID)

      result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15, stakes_quality: true)
      expect(result).to include gold, platinum
      expect(result).not_to include unranked, bronze, silver
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:legacy_horse, :stallion, Owner: 35)
    ff = create(:legacy_horse, :stallion, :final_furlong)

    result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  it "ignores already consigned horses" do
    already_consigned_1 = create(:legacy_horse, :stallion, :final_furlong)
    already_con_1_horse = create(:horse, :stallion, legacy_id: already_consigned_1.ID)
    create(:auction_horse, horse: already_con_1_horse)
    ff = create(:legacy_horse, :stallion, :final_furlong)
    ff2 = create(:legacy_horse, :stallion, :final_furlong)

    result = described_class.new.select_horses(number: 2, min_age: 4, max_age: 15)
    expect(result.size).to eq 2
    expect(result).to include ff, ff2
    expect(result).not_to include already_con_1_horse
  end
end

