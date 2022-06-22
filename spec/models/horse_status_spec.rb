require "spec_helper"

RSpec.describe HorseStatus do
  describe "constants" do
    it "defines statuses" do
      expect(described_class::STATUSES).to eq({
                                                unborn: "unborn", weanling: "weanling", yearling: "yearling",
                                                racehorse: "racehorse", broodmare: "broodmare", stallion: "stallion",
                                                retired: "retired", retired_broodmare: "retired_broodmare",
                                                retired_stallion: "retired_stallion", deceased: "deceased"
                                              })
    end

    it "defines statuses that are alive" do
      expect(described_class::LIVING_STATUSES).to eq(
        %w[weanling yearling racehorse broodmare stallion retired retired_broodmare retired_stallion]
      )
    end

    it "defines statuses that are active (non-retired/non-foal)" do
      expect(described_class::ACTIVE_STATUSES).to eq(%w[racehorse broodmare stallion])
    end

    it "defines statuses that are active for breeding (non-retired)" do
      expect(described_class::ACTIVE_BREEDING_STATUSES).to eq(%w[broodmare stallion])
    end

    it "defines statuses that include breeding + retired" do
      expect(described_class::BREEDING_STATUSES).to eq(
        %w[broodmare stallion retired_broodmare retired_stallion]
      )
    end
  end

  describe "#to_s" do
    it "returns status" do
      expect(described_class.new(:racehorse).to_s).to eq "racehorse"
    end
  end

  describe "#living?" do
    context "when status is one of the living" do
      it "returns true" do
        status = described_class.new(described_class::LIVING_STATUSES.sample)
        expect(status.living?).to be true
      end
    end

    context "when status is deceased" do
      it "returns false" do
        expect(described_class.new(:deceased).living?).to be false
      end
    end
  end

  describe "#active?" do
    context "when status is one of the active ones" do
      it "returns true" do
        status = described_class.new(described_class::ACTIVE_STATUSES.sample)
        expect(status.active?).to be true
      end
    end

    context "when status is retired" do
      it "returns false" do
        option = %w[retired retired_stallion retired_broodmare].sample
        expect(described_class.new(option).active?).to be false
      end
    end
  end

  describe "#active_breeding?" do
    context "when status is one of the active ones" do
      it "returns true" do
        status = described_class.new(described_class::ACTIVE_BREEDING_STATUSES.sample)
        expect(status.active_breeding?).to be true
      end
    end

    context "when status is retired" do
      it "returns false" do
        option = %w[retired_stallion retired_broodmare].sample
        expect(described_class.new(option).active_breeding?).to be false
      end
    end
  end

  describe "#breeding?" do
    context "when status is one of the breeding ones" do
      it "returns true" do
        status = described_class.new(described_class::BREEDING_STATUSES.sample)
        expect(status.breeding?).to be true
      end
    end

    context "when status is foal" do
      it "returns false" do
        option = %w[weanling yearling].sample
        expect(described_class.new(option).breeding?).to be false
      end
    end
  end
end
