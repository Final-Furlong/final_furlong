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

      result = described_class.new.select_horses(number: 10, min_age: 6, max_age: 6)
      expect(result).to include younger
      expect(result).not_to include older
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:horse, :broodmare)
    ff = create(:horse, :broodmare, :final_furlong)

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

    result = described_class.new.select_horses(number: 2, min_age: 4, max_age: 15)
    expect(result.size).to eq 2
    expect(result).to include ff, ff2
    expect(result).not_to include already_consigned
  end
  # rubocop:enable RSpec/ExampleLength
end

