RSpec.describe Auctions::RacehorseConsigner do
  context "when number is 0" do
    it "returns 0 horses" do
      create(:horse, :racehorse, :final_furlong)
      create_views
      expect(described_class.new.select_horses(number: 0, min_age: 2, max_age: 4).count).to eq 0
    end
  end

  context "when min age = max age" do
    it "only returns horses of that age" do
      two_yo = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 2.years)
      three_yo = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 3.years)
      create(:race_result_horse, horse: two_yo, finish_position: 1, race: create(:race_result, race_type: "maiden"))
      create(:race_result_horse, horse: three_yo, finish_position: 1, race: create(:race_result, race_type: "maiden"))
      create_views

      result = described_class.new.select_horses(number: 10, min_age: 2, max_age: 2)
      expect(result).to include two_yo
      expect(result).not_to include three_yo
    end
  end

  context "when stakes quality is false" do
    it "only returns non-stakes horses" do
      unraced = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 2.years)
      non_stakes = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 2.years)
      stakes = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 3.years)
      create(:race_result_horse, horse: non_stakes, finish_position: 1, race: create(:race_result, race_type: "maiden"))
      create(:race_result_horse, horse: stakes, finish_position: 1, race: create(:race_result, race_type: "stakes", grade: "Ungraded", name: "Foo"))
      create_views

      result = described_class.new.select_horses(number: 10, min_age: 2, max_age: 6, stakes_quality: false)
      expect(result).to include non_stakes, unraced
      expect(result).not_to include stakes
    end
  end

  context "when stakes quality is true" do
    it "only returns stakes horses" do
      non_stakes = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 2.years)
      stakes = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 3.years)
      stakes2 = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 3.years)
      create(:race_result_horse, horse: non_stakes, finish_position: 1, race: create(:race_result, race_type: "maiden"))
      create(:race_result_horse, horse: stakes, finish_position: 1, race: create(:race_result, race_type: "stakes", grade: "Ungraded", name: "Foo"))
      create(:race_result_horse, horse: stakes2, finish_position: 2, race: create(:race_result, race_type: "stakes", grade: "Ungraded", name: "Foo"))
      create_views

      result = described_class.new.select_horses(number: 10, min_age: 2, max_age: 6, stakes_quality: true)
      expect(result).to include stakes, stakes2
      expect(result).not_to include non_stakes
    end
  end

  it "only returns horses owned by FF" do
    non_ff = create(:horse, :racehorse, date_of_birth: Date.current - 3.years)
    ff = create(:horse, :racehorse, :final_furlong, date_of_birth: Date.current - 3.years)
    create(:race_result_horse, horse: non_ff, finish_position: 1, race: create(:race_result, race_type: "maiden"))
    create(:race_result_horse, horse: ff, finish_position: 1, race: create(:race_result, race_type: "maiden"))
    create_views

    result = described_class.new.select_horses(number: 10, min_age: 2, max_age: 6)
    expect(result).to include ff
    expect(result).not_to include non_ff
  end

  # rubocop:disable RSpec/ExampleLength
  it "ignores already consigned horses" do
    Horses::Horse.destroy_all
    already_consigned = create(:horse, :racehorse, :final_furlong)
    create(:auction_horse, horse: already_consigned)
    ff = create(:horse, :racehorse, :final_furlong)
    ff2 = create(:horse, :racehorse, :final_furlong)
    create(:race_result_horse, horse: ff, finish_position: 1, race: create(:race_result, race_type: "maiden"))
    create(:race_result_horse, horse: ff2, finish_position: 1, race: create(:race_result, race_type: "maiden"))
    create_views

    result = described_class.new.select_horses(number: 2, min_age: 2, max_age: 5)
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

