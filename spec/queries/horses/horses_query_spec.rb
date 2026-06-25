describe Horses::HorsesQuery do
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
end

