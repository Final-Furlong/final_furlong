RSpec.describe Game::BreedingSeason do
  describe ".start_date" do
    it "returns current year's start date" do
      expect(described_class.start_date).to eq Date.new(Date.current.year, 2, 15)
    end

    it "returns another year's start date" do
      year = Date.current.year + rand(-10..10)
      expect(described_class.start_date(year)).to eq Date.new(year, 2, 15)
    end
  end

  describe ".end_date" do
    it "returns current year's end date" do
      expect(described_class.end_date).to eq Date.new(Date.current.year, 8, 31)
    end

    it "returns another year's end date" do
      year = Date.current.year + rand(-10..10)
      expect(described_class.end_date(year)).to eq Date.new(year, 8, 31)
    end
  end

  describe ".breeding_season_date" do
    it "returns true when the date falls within the breeding season" do
      date = Date.new(Date.current.year, 5, 31)
      expect(described_class.breeding_season_date?(date)).to be true
    end

    it "returns false when the date is before the breeding season" do
      date = Date.new(Date.current.year, 1, 31)
      expect(described_class.breeding_season_date?(date)).to be false
    end

    it "returns false when the date is after the breeding season" do
      date = Date.new(Date.current.year, 9, 1)
      expect(described_class.breeding_season_date?(date)).to be false
    end
  end

  describe ".pre_breeding_season_date" do
    it "returns true when the date falls within the period before start of breeding season" do
      date = Date.new(Date.current.year, 1, 15)
      expect(described_class.pre_breeding_season_date?(date, 40)).to be true
    end

    it "returns false when the date is before the period before start of breeding season" do
      date = Date.new(Date.current.year, 1, 10)
      expect(described_class.pre_breeding_season_date?(date, 15)).to be false
    end

    it "returns false when the date is after the period before start of breeding season" do
      date = Date.new(Date.current.year, 2, 16)
      expect(described_class.pre_breeding_season_date?(date, 1)).to be false
    end
  end

  describe ".next_season_start_date" do
    it "returns current season start date when the breeding season has not yet started" do
      travel_to Date.new(Date.current.year, 1, 15) do
        date = Date.new(Date.current.year, 2, 15)
        expect(described_class.next_season_start_date).to eq date
      end
    end

    it "returns next year start date when the breeding season has started" do
      travel_to Date.new(Date.current.year, 3, 15) do
        date = Date.new(Date.current.year + 1, 2, 15)
        expect(described_class.next_season_start_date).to eq date
      end
    end
  end
end

