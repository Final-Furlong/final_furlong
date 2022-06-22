require "spec_helper"

RSpec.describe HorseGender do
  describe "constants" do
    it "defines genders" do
      expect(described_class::VALUES).to eq({
                                              colt: "colt", filly: "filly", mare: "mare", stallion: "stallion", gelding: "gelding"
                                            })
    end

    it "defines statuses that are male" do
      expect(described_class::MALE_GENDERS).to eq(%w[colt stallion gelding])
    end

    it "defines statuses that are female" do
      expect(described_class::FEMALE_GENDERS).to eq(%w[filly mare])
    end

    it "defines statuses that are breedable" do
      expect(described_class::BREEDABLE_GENDERS).to eq(%w[mare stallion])
    end
  end

  describe "#to_s" do
    it "returns gender" do
      expect(described_class.new(:colt).to_s).to eq "colt"
    end
  end

  describe "#male?" do
    context "when gender is male" do
      it "returns true" do
        gender = described_class.new(described_class::MALE_GENDERS.sample)
        expect(gender.male?).to be true
      end
    end

    context "when gender is female" do
      it "returns false" do
        expect(described_class.new(:mare).male?).to be false
      end
    end
  end

  describe "#female?" do
    context "when gender is female" do
      it "returns true" do
        gender = described_class.new(described_class::FEMALE_GENDERS.sample)
        expect(gender.female?).to be true
      end
    end

    context "when gender is male" do
      it "returns false" do
        gender = %w[colt stallion gelding].sample
        expect(described_class.new(gender).female?).to be false
      end
    end
  end

  describe "#breedable?" do
    context "when gender is mare or stallion" do
      it "returns true" do
        gender = described_class.new(described_class::BREEDABLE_GENDERS.sample)
        expect(gender.breedable?).to be true
      end
    end

    context "when gender is gelding or immature" do
      it "returns false" do
        gender = %w[colt filly gelding].sample
        expect(described_class.new(gender).breedable?).to be false
      end
    end
  end
end
