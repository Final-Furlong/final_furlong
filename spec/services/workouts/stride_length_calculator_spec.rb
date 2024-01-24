RSpec.describe Workouts::StrideLengthCalculator do
  let(:weight_modifier) { rand(0..20).fdiv(10) }
  let(:equipment_status) { Racing::EquipmentStatusGenerator::STATUS_MODIFIERS[Racing::EquipmentStatusGenerator::STATUS_MODIFIERS.keys.sample] }
  let(:track_preference) { rand(96..105).fdiv(100) }
  let(:track_condition) { rand(96..105).fdiv(100) }
  let(:consistency) { rand(80..99).fdiv(100) }

  describe "#call" do
    context "when walking" do
      it "is correct" do
        100.times do |n|
          calculator = described_class.new(
            activity: "walk", stride_length: 0, effort: n, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency
          )
          min_value = 36 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          max_value = 48 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          expect(calculator.call).to be_between(min_value, max_value)
        end
      end
    end

    context "when trotting" do
      it "is correct" do
        100.times do |n|
          calculator = described_class.new(
            activity: "trot", stride_length: 0, effort: n, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency
          )
          min_value = 48 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          max_value = 84 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          expect(calculator.call).to be_between(min_value, max_value)
        end
      end
    end

    context "when jogging" do
      it "is correct" do
        100.times do |n|
          calculator = described_class.new(
            activity: "jog", stride_length: 0, effort: n, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency
          )
          min_value = 48 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          max_value = 84 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          expect(calculator.call).to be_between(min_value, max_value)
        end
      end
    end

    context "when cantering" do
      it "is correct" do
        100.times do |n|
          calculator = described_class.new(
            activity: "canter", stride_length: 0, effort: n, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency
          )
          min_value = 120 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          max_value = 144 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          expect(calculator.call).to be_between(min_value, max_value)
        end
      end
    end

    context "when galloping" do
      it "is correct" do
        100.times do |n|
          calculator = described_class.new(
            activity: "gallop", stride_length: 100, effort: n, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency
          )
          min_value = 89 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          max_value = 99 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          expect(calculator.call).to be_between(min_value, max_value)
        end
      end
    end

    context "when breezing" do
      it "is correct" do
        100.times do |n|
          calculator = described_class.new(
            activity: "breeze", stride_length: 100, effort: n, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency
          )
          min_value = 89 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          max_value = 99 * (n / 100) * weight_modifier * equipment_status * track_preference * track_condition * consistency
          expect(calculator.call).to be_between(min_value, max_value)
        end
      end
    end

    context "when other activity" do
      it "raises error" do
        calculator = described_class.new(
          activity: "grazing", stride_length: 0, effort: 100, weight: weight_modifier, equipment_status: equipment_status,
          track_preference: track_preference, track_condition: track_condition, consistency: consistency
        )
        expect { calculator.call }.to raise_error ArgumentError, "Unrecognized activity: grazing"
      end
    end

    context "when invalid effort" do
      it "raises error" do
        expect do
          described_class.new(activity: "walk", stride_length: 0, effort: 1000, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency)
        end.to raise_error ArgumentError, "Invalid effort: 1000"
      end
    end

    context "when invalid weight modifier" do
      it "raises error" do
        expect do
          described_class.new(activity: "walk", stride_length: 0, effort: 100, weight: 3.0, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency)
        end.to raise_error ArgumentError, "Invalid weight modifier: 3.0"
      end
    end

    context "when invalid equipment status" do
      it "raises error" do
        expect do
          described_class.new(activity: "walk", stride_length: 0, effort: 100, weight: weight_modifier, equipment_status: 0.1,
            track_preference: track_preference, track_condition: track_condition, consistency: consistency)
        end.to raise_error ArgumentError, "Invalid equipment status modifier: 0.1"
      end
    end

    context "when invalid track preference" do
      it "raises error" do
        expect do
          described_class.new(activity: "walk", stride_length: 0, effort: 100, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: 0.5, track_condition: track_condition, consistency: consistency)
        end.to raise_error ArgumentError, "Invalid track preference modifier: 0.5"
      end
    end

    context "when invalid track condition" do
      it "raises error" do
        expect do
          described_class.new(activity: "walk", stride_length: 0, effort: 100, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: 0.5, consistency: consistency)
        end.to raise_error ArgumentError, "Invalid track condition modifier: 0.5"
      end
    end

    context "when invalid consistency" do
      it "raises error" do
        expect do
          described_class.new(activity: "walk", stride_length: 0, effort: 100, weight: weight_modifier, equipment_status: equipment_status,
            track_preference: track_preference, track_condition: track_condition, consistency: 0.5)
        end.to raise_error ArgumentError, "Invalid consistency modifier: 0.5"
      end
    end
  end
end

