RSpec.describe Auctions::BroodmareConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:horse, :broodmare, :final_furlong)
      expect(described_class.new.select_horses(number: 0, min_age: 4, max_age: 10).count).to eq 0
    end
  end

  context "when min age = max age" do
    it "only returns horses of that age" do
      younger = create(:horse, :broodmare, :final_furlong, date_of_birth: Date.current - 6.years)
      older = create(:horse, :broodmare, :final_furlong, date_of_birth: Date.current - 7.years)
      create(:broodmare_foal_record, mare: younger, breed_ranking: nil)
      create(:broodmare_foal_record, mare: older, breed_ranking: nil)

      result = described_class.new.select_horses(number: 10, min_age: 6, max_age: 6)
      expect(result).to include younger
      expect(result).not_to include older
    end
  end

  context "when stakes quality is false" do
    it "only returns non-silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      unranked = create(:horse, :broodmare, :final_furlong)
      bronze = create(:horse, :broodmare, :final_furlong)
      silver = create(:horse, :broodmare, :final_furlong)
      gold = create(:horse, :broodmare, :final_furlong)
      platinum = create(:horse, :broodmare, :final_furlong)
      create(:broodmare_foal_record, mare: unranked)
      create(:broodmare_foal_record, :bronze, mare: bronze)
      create(:broodmare_foal_record, :silver, mare: silver)
      create(:broodmare_foal_record, :gold, mare: gold)
      create(:broodmare_foal_record, :platinum, mare: platinum)

      result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15, stakes_quality: false)
      expect(result).to include unranked, bronze, silver
      expect(result).not_to include gold, platinum
    end
  end

  context "when stakes quality is true" do
    it "only returns silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      unranked = create(:horse, :broodmare, :final_furlong)
      bronze = create(:horse, :broodmare, :final_furlong)
      silver = create(:horse, :broodmare, :final_furlong)
      gold = create(:horse, :broodmare, :final_furlong)
      platinum = create(:horse, :broodmare, :final_furlong)
      create(:broodmare_foal_record, mare: unranked)
      create(:broodmare_foal_record, :bronze, mare: bronze)
      create(:broodmare_foal_record, :silver, mare: silver)
      create(:broodmare_foal_record, :gold, mare: gold)
      create(:broodmare_foal_record, :platinum, mare: platinum)
      create_views

      result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15, stakes_quality: true)
      expect(result).to include gold, platinum
      expect(result).not_to include unranked, bronze, silver
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:horse, :broodmare)
    ff = create(:horse, :broodmare, :final_furlong)
    create(:broodmare_foal_record, mare: non_ff, breed_ranking: nil)
    create(:broodmare_foal_record, mare: ff, breed_ranking: nil)

    result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  # rubocop:disable RSpec/ExampleLength
  it "ignores already consigned horses" do
    already_consigned = create(:horse, :broodmare, :final_furlong)
    create(:auction_horse, horse: already_consigned)
    ff = create(:horse, :broodmare, :final_furlong)
    ff2 = create(:horse, :broodmare, :final_furlong)
    create(:broodmare_foal_record, mare: already_consigned, breed_ranking: nil)
    create(:broodmare_foal_record, mare: ff, breed_ranking: nil)
    create(:broodmare_foal_record, mare: ff2, breed_ranking: nil)

    result = described_class.new.select_horses(number: 2, min_age: 4, max_age: 15)
    expect(result.size).to eq 2
    expect(result).to include ff, ff2
    expect(result).not_to include already_consigned
  end
  # rubocop:enable RSpec/ExampleLength

  def create_views
    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
  end
end

