RSpec.describe Auctions::StallionConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:horse, :stallion, :final_furlong)
      expect(described_class.new.select_horses(number: 0, min_age: 4, max_age: 10).count).to eq 0
    end
  end

  context "when min age = max age" do
    it "only returns horses of that age" do
      younger = create(:horse, :stallion, :final_furlong, date_of_birth: Date.current - 6.years)
      older = create(:horse, :stallion, :final_furlong, date_of_birth: Date.current - 7.years)
      create(:stud_foal_record, stud: younger)
      create(:stud_foal_record, stud: older)

      result = described_class.new.select_horses(number: 10, min_age: 6, max_age: 6)
      expect(result).to include younger
      expect(result).not_to include older
    end
  end

  context "when stakes quality is false" do
    it "only returns non-silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      unranked = create(:horse, :stallion, :final_furlong)
      bronze = create(:horse, :stallion, :final_furlong)
      silver = create(:horse, :stallion, :final_furlong)
      gold = create(:horse, :stallion, :final_furlong)
      platinum = create(:horse, :stallion, :final_furlong)
      create(:stud_foal_record, stud: unranked)
      create(:stud_foal_record, :bronze, stud: bronze)
      create(:stud_foal_record, :silver, stud: silver)
      create(:stud_foal_record, :gold, stud: gold)
      create(:stud_foal_record, :platinum, stud: platinum)

      result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15, stakes_quality: false)
      expect(result).to include unranked, bronze, silver
      expect(result).not_to include gold, platinum
    end
  end

  context "when stakes quality is true" do
    it "only returns silver/gold ranked horses" do # rubocop:disable RSpec/ExampleLength
      unranked = create(:horse, :stallion, :final_furlong)
      bronze = create(:horse, :stallion, :final_furlong)
      silver = create(:horse, :stallion, :final_furlong)
      gold = create(:horse, :stallion, :final_furlong)
      platinum = create(:horse, :stallion, :final_furlong)
      create(:stud_foal_record, stud: unranked)
      create(:stud_foal_record, :bronze, stud: bronze)
      create(:stud_foal_record, :silver, stud: silver)
      create(:stud_foal_record, :gold, stud: gold)
      create(:stud_foal_record, :platinum, stud: platinum)

      result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15, stakes_quality: true)
      expect(result).to include gold, platinum
      expect(result).not_to include unranked, bronze, silver
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:horse, :stallion)
    ff = create(:horse, :stallion, :final_furlong)
    create(:stud_foal_record, stud: non_ff)
    create(:stud_foal_record, stud: ff)

    result = described_class.new.select_horses(number: 10, min_age: 4, max_age: 15)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  it "ignores already consigned horses" do
    already_consigned = create(:horse, :stallion, :final_furlong)
    create(:auction_horse, horse: already_consigned)
    ff = create(:horse, :stallion, :final_furlong)
    ff2 = create(:horse, :stallion, :final_furlong)
    create(:stud_foal_record, stud: ff)
    create(:stud_foal_record, stud: ff2)

    result = described_class.new.select_horses(number: 2, min_age: 4, max_age: 15)
    expect(result.size).to eq 2
    expect(result).to include ff, ff2
    expect(result).not_to include already_consigned
  end
end

