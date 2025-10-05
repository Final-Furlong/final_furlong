require_relative "../../shared/horse_examples"

RSpec.describe Horses::Stallion do
  it_behaves_like "a horse"

  describe "class" do
    it "is a horse" do
      expect(described_class.new).to be_a Horses::Horse
    end
  end

  describe "assocations" do
    it { is_expected.to have_many(:foals).class_name("Horse").inverse_of(:sire) }
  end

  describe "validations" do
    describe "status" do
      it "is valid for stallion" do
        horse = build_stubbed(:horse, :stallion)

        expect(horse).to be_valid
      end

      it "is valid for retired_stallion" do
        horse = build_stubbed(:horse, :stallion, status: "retired_stud")

        expect(horse).to be_valid
      end
    end

    describe "gender" do
      it "is valid for stallion" do
        horse = build_stubbed(:horse, :stallion)

        expect(horse).to be_valid
      end

      it "is valid for gelding" do
        horse = build_stubbed(:horse, :stallion, gender: "gelding")

        expect(horse).to be_valid
      end
    end
  end
end

