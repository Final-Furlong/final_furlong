require "rails_helper"
require_relative "../../shared/horse_examples"

RSpec.describe Horses::Horse do
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
        expect(horse.errors[:name]).to eq(["can't be blank"])
      end

      it "can be blank for an unnamed horse whose name is not being edited" do
        horse = create(:horse, name: nil)
        horse.status = "racehorse"

        expect(horse).to be_valid
      end

      it "is valid for a horse whose name is not being edited" do
        horse = create(:horse, name: "Bob", status: "yearling")
        horse.status = "racehorse"
        horse.name = "Bob2"

        expect(horse).to be_valid
      end
    end
  end

  describe "#stillborn?" do
    context "when date of birth == date of death" do
      it "returns true" do
        horse = build_stubbed(:horse, :stillborn)

        expect(horse.stillborn?).to be true
      end
    end

    context "when date of birth != date of death" do
      it "returns false" do
        horse = build_stubbed(:horse)

        expect(horse.stillborn?).to be false
      end
    end
  end

  describe "#dead?" do
    context "when date of birth == date of death" do
      it "returns true" do
        horse = described_class.new(date_of_birth: Date.current, date_of_death: Date.current)

        expect(horse.dead?).to be true
      end
    end

    context "when date of death is nil" do
      it "returns false" do
        horse = described_class.new(date_of_birth: Date.current, date_of_death: nil)

        expect(horse.dead?).to be false
      end
    end

    context "when date of death > date of birth" do
      it "returns true" do
        horse = described_class.new(date_of_birth: Date.current - 1.day, date_of_death: Date.current)

        expect(horse.dead?).to be true
      end
    end
  end

  describe ".ransackable_attributes" do
    it "returns correct fields" do
      expect(described_class.ransackable_attributes).to match_array(
        %w[age breeder_id dam_id date_of_birth date_of_death foals_count gender location_bred_id name owner_id sire_id status unborn_foals_count]
      )
    end
  end

  describe ".ransackable_associations" do
    it "returns correct list" do
      expect(described_class.ransackable_associations).to match_array(
        %w[breeder dam location_bred owner sire]
      )
    end
  end
end

