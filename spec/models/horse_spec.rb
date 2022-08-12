require "rails_helper"
require_relative "../shared/horse_examples"

RSpec.describe Horse, type: :model do
  it_behaves_like "a horse"

  describe "validations" do
    describe "name" do
      it "can be blank for a new horse" do
        horse = build(:horse, name: nil)
        expect(horse).to be_valid
      end

      it "cannot be blank for a horse who already has a name" do
        horse = create(:horse, name: "Bob")
        horse.name = nil
        expect(horse).not_to be_valid
        expect(horse.errors[:name]).to eq(["can't be blank", "has already been taken"])
      end
    end
  end

  describe "#status" do
    context "when horse has no status" do
      it "returns nil" do
        horse = described_class.new
        horse.status = nil

        expect(horse.status).to be_nil
      end
    end

    context "when horse has status" do
      let(:horse) { build_stubbed(:horse, :broodmare) }

      it "returns HorseStatus" do
        expect(horse.status).to be_a HorseStatus
      end
    end
  end

  describe "#gender" do
    let(:horse) { build_stubbed(:horse, :broodmare) }

    it "returns HorseGender" do
      expect(horse.gender).to be_a HorseGender
    end
  end

  describe "#age" do
    context "when stillborn" do
      let(:horse) { build_stubbed(:horse, :stillborn) }

      it "returns 0" do
        expect(horse.age).to eq 0
      end
    end

    context "when alive" do
      let(:date_of_birth) { Date.current - 3.years }
      let(:date_of_death) { nil }
      let(:horse) { build_stubbed(:horse, date_of_birth:, date_of_death:) }

      it "returns current age" do
        expect(horse.age).to eq 3
      end
    end

    context "when deceased" do
      let(:date_of_birth) { Date.current - 8.years }
      let(:date_of_death) { Date.current - 1.year }
      let(:horse) { build_stubbed(:horse, date_of_birth:, date_of_death:) }

      it "returns age at death" do
        expect(horse.age).to eq 7
      end
    end
  end

  describe "#stillborn?" do
    context "when date of birth == date of death" do
      let(:horse) { build_stubbed(:horse, :stillborn) }

      it "returns true" do
        expect(horse.stillborn?).to be true
      end
    end

    context "when date of birth != date of death" do
      let(:horse) { build_stubbed(:horse) }

      it "returns false" do
        expect(horse.stillborn?).to be false
      end
    end
  end
end

