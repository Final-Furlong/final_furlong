RSpec.describe Auctions::WeanlingConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:horse, :weanling, :final_furlong)
      expect(described_class.new.select_horses(number: 0).count).to eq 0
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:horse, :weanling)
    ff = create(:horse, :weanling, :final_furlong)

    result = described_class.new.select_horses(number: 10, min_age: 0, max_age: 0)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  it "ignores already consigned horses" do
    already_consigned = create(:horse, :weanling, :final_furlong)
    create(:auction_horse, horse: already_consigned)
    ff = create(:horse, :weanling, :final_furlong)
    ff2 = create(:horse, :weanling, :final_furlong)

    result = described_class.new.select_horses(number: 2, min_age: 0, max_age: 0)
    expect(result.size).to eq 2
    expect(result).to include ff, ff2
    expect(result).not_to include already_consigned
  end
end

