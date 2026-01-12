RSpec.describe Workouts::EnergyLossCalculator do
  subject(:calculator) { described_class.new(activity) }

  let(:activity) { "walk" }

  describe "#call" do
    context "when walking" do
      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0012, 0.0014)
        end
      end
    end

    context "when trotting" do
      let(:activity) { "trot" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0045, 0.0056)
        end
      end
    end

    context "when jogging" do
      let(:activity) { "jog" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0045, 0.0056)
        end
      end
    end

    context "when cantering" do
      let(:activity) { "canter" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0112, 0.0137)
        end
      end
    end

    context "when galloping" do
      let(:activity) { "gallop" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.022, 0.027)
        end
      end
    end

    context "when breezing" do
      let(:activity) { "breeze" }

      it "is correct" do
        100.times do
          expect(calculator.call).to be_between(0.0337, 0.0412)
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

