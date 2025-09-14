RSpec.describe Horses::HorsesQuery do
  subject(:query) { described_class.new }

  describe ".name_matches" do
    context "when name is blank" do
      it "returns empty AR query" do
        expect(query.name_matches(name: nil)).to eq Horses::Horse.none
      end
    end

    context "when name is the same" do
      it "returns matching horse" do
        horse = create(:horse, name: "Bob")

        expect(query.name_matches(name: "Bob")).to eq([horse])
      end
    end

    context "when name is the same except for case" do
      it "returns matching horse" do
        horse = create(:horse, name: "Bob")

        expect(query.name_matches(name: "BOB")).to eq([horse])
      end
    end

    context "when name is the same except for whitespace" do
      it "returns matching horse" do
        horse = create(:horse, name: "Bob Champion")

        expect(query.name_matches(name: "BobChampion")).to eq([horse])
      end
    end

    context "when name is the same except for ." do
      it "returns matching horse" do
        horse = create(:horse, name: "Bob.Champion")

        expect(query.name_matches(name: "BobChampion")).to eq([horse])
      end
    end

    context "when name is the same except for -" do
      it "returns matching horse" do
        horse = create(:horse, name: "Bob-Champion")

        expect(query.name_matches(name: "BobChampion")).to eq([horse])
      end
    end

    context "when name is the same except for &" do
      it "returns matching horse" do
        horse = create(:horse, name: "Bob&Champion")

        expect(query.name_matches(name: "BobChampion")).to eq([horse])
      end
    end
  end

  describe ".born" do
    it "returns horses who are not unborn" do
      horse = create(:horse, :racehorse)
      unborn = create(:horse, :unborn)

      result = query.born
      expect(result).to include horse
      expect(result).not_to include unborn
    end
  end

  describe ".living" do
    it "returns horses who are not dead or unborn" do
      horse = create(:horse, :racehorse)
      unborn = create(:horse, :unborn)
      dead = create(:horse, :dead)

      result = query.living
      expect(result).to include horse
      expect(result).not_to include unborn, dead
    end
  end

  describe ".retired" do
    it "returns horses who are retired" do
      horse = create(:horse, :racehorse)
      retired = create(:horse, :retired)
      stud = create(:horse, :retired_stud)
      mare = create(:horse, :retired_broodmare)

      result = query.retired
      expect(result).to include retired, stud, mare
      expect(result).not_to include horse
    end
  end

  describe ".oredered" do
    it "returns horses sorted by name ascending" do
      horse1 = create(:horse, :racehorse, name: "Abc")
      horse2 = create(:horse, :racehorse, name: "Def")
      horse3 = create(:horse, :racehorse, name: "Ghi")

      expect(query.ordered.to_a).to eq([horse1, horse2, horse3])
    end
  end

  describe ".owned_by" do
    it "returns horses owned by stable" do
      stable = create(:stable)
      owned_horse = create(:horse, owner: stable)
      not_owned_horse = create(:horse)

      result = query.owned_by(stable)
      expect(result).to include(owned_horse)
      expect(result).not_to include(not_owned_horse)
    end
  end

  describe ".sort_by_status_asc" do
    it "returns horses sorted by status ascending" do # rubocop:disable RSpec/ExampleLength
      broodmare = create(:horse, :broodmare)
      dead = create(:horse, :dead, name: "Alpha")
      stillborn = create(:horse, :stillborn, name: "Beta")
      racehorse = create(:horse, :racehorse)
      retired = create(:horse, :retired)
      retired_broodmare = create(:horse, :retired_broodmare)
      retired_stud = create(:horse, :retired_stud)
      stud = create(:horse, :stud)
      weanling = create(:horse, :weanling)
      yearling = create(:horse, :yearling)

      result = query.sort_by_status_asc.to_a
      expect(result).to eq([
        broodmare,
        dead,
        stillborn,
        racehorse,
        retired,
        retired_broodmare,
        retired_stud,
        stud,
        weanling,
        yearling
      ])
    end
  end
end

