RSpec.describe Racing::TrackTypePreferenceCalculator do
  describe "#call" do
    context "when dirt track" do
      it "is correct" do
        10.times do |n|
          calculator = described_class.new(track_type: "dirt", dirt: n + 1, turf: 1, steeplechase: 1)
          expect(calculator.call).to eq expected_value(n + 1)
        end
      end
    end

    context "when turf track" do
      it "is correct" do
        10.times do |n|
          calculator = described_class.new(track_type: "turf", dirt: 1, turf: n + 1, steeplechase: 1)
          expect(calculator.call).to eq expected_value(n + 1)
        end
      end
    end

    context "when steeplechase track" do
      it "is correct" do
        10.times do |n|
          calculator = described_class.new(track_type: "steeplechase", dirt: 1, turf: 1, steeplechase: n + 1)
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

