RSpec.describe Workouts::FitnessGainCalculator do
  subject(:calculator) { described_class.new(activity) }

  let(:activity) { "walk" }

  describe "#call" do
    context "when walking" do
      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0045, 0.0061)
        end
      end
    end

    context "when trotting" do
      let(:activity) { "trot" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0182, 0.0318)
        end
      end
    end

    context "when jogging" do
      let(:activity) { "jog" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0182, 0.0318)
        end
      end
    end

    context "when cantering" do
      let(:activity) { "canter" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0758, 0.0909)
        end
      end
    end

    context "when galloping" do
      let(:activity) { "gallop" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.2879, 0.3182)
        end
      end
    end

    context "when breezing" do
      let(:activity) { "breeze" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.5000, 0.5455)
        end
      end
    end

    context "when other activity" do
      let(:activity) { "grazing" }

      it "raises error" do
        expect { calculator.call }.to raise_error ArgumentError, "Unrecognized activity: grazing"
      end
    end
  end
end

