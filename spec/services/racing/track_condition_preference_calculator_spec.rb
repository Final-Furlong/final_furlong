RSpec.describe Racing::TrackConditionPreferenceCalculator do
  describe "#call" do
    context "when fast track" do
      it "is correct" do
        10.times do |n|
          calculator = described_class.new(track_condition: "fast", fast: n + 1, good: 1, wet: 1, slow: 1)
          expect(calculator.call).to eq expected_value(n + 1)
        end
      end
    end

    context "when good track" do
      it "is correct" do
        10.times do |n|
          calculator = described_class.new(track_condition: "good", fast: 1, good: n + 1, wet: 1, slow: 1)
          expect(calculator.call).to eq expected_value(n + 1)
        end
      end
    end

    context "when wet track" do
      it "is correct" do
        10.times do |n|
          calculator = described_class.new(track_condition: "wet", fast: 1, good: 1, wet: n + 1, slow: 1)
          expect(calculator.call).to eq expected_value(n + 1)
        end
      end
    end

    context "when slow track" do
      it "is correct" do
        10.times do |n|
          calculator = described_class.new(track_condition: "slow", fast: 1, good: 1, wet: 1, slow: n + 1)
          expect(calculator.call).to eq expected_value(n + 1)
        end
      end
    end
  end

  private

  def expected_value(input)
    case input
    when 1
      0.96
    when 2
      0.97
    when 3
      0.98
    when 4
      0.99
    when 5
      1.00
    when 6
      1.01
    when 7
      1.02
    when 8
      1.03
    when 9
      1.04
    when 10
      1.05
    end
  end
end

