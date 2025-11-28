RSpec.describe Racing::TrainingScheduleActivity do
  describe "validations" do
    it { is_expected.to validate_inclusion_of(:activity1).in_array(Config::Workouts.activities).allow_blank }
    it { is_expected.to validate_inclusion_of(:activity2).in_array(Config::Workouts.activities).allow_blank }
    it { is_expected.to validate_inclusion_of(:activity3).in_array(Config::Workouts.activities).allow_blank }
    it { is_expected.to validate_inclusion_of(:distance1).in_array(Config::Workouts.distances).allow_blank }
    it { is_expected.to validate_inclusion_of(:distance2).in_array(Config::Workouts.distances).allow_blank }
    it { is_expected.to validate_inclusion_of(:distance3).in_array(Config::Workouts.distances).allow_blank }

    context "when walking" do
      subject { described_class.new(activity1: "walk", activity2: "walk", activity3: "walk") }

      it { is_expected.to validate_inclusion_of(:distance1).in_array(Config::Workouts.dig(:walk, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance2).in_array(Config::Workouts.dig(:walk, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance3).in_array(Config::Workouts.dig(:walk, :distances)) }
    end

    context "when jogging" do
      subject { described_class.new(activity1: "jog", activity2: "jog", activity3: "jog") }

      it { is_expected.to validate_inclusion_of(:distance1).in_array(Config::Workouts.dig(:jog, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance2).in_array(Config::Workouts.dig(:jog, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance3).in_array(Config::Workouts.dig(:jog, :distances)) }
    end

    context "when cantering" do
      subject { described_class.new(activity1: "canter", activity2: "canter", activity3: "canter") }

      it { is_expected.to validate_inclusion_of(:distance1).in_array(Config::Workouts.dig(:canter, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance2).in_array(Config::Workouts.dig(:canter, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance3).in_array(Config::Workouts.dig(:canter, :distances)) }
    end

    context "when galloping" do
      subject { described_class.new(activity1: "gallop", activity2: "gallop", activity3: "gallop") }

      it { is_expected.to validate_inclusion_of(:distance1).in_array(Config::Workouts.dig(:gallop, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance2).in_array(Config::Workouts.dig(:gallop, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance3).in_array(Config::Workouts.dig(:gallop, :distances)) }
    end

    context "when breezing" do
      subject { described_class.new(activity1: "breeze", activity2: "breeze", activity3: "breeze") }

      it { is_expected.to validate_inclusion_of(:distance1).in_array(Config::Workouts.dig(:breeze, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance2).in_array(Config::Workouts.dig(:breeze, :distances)) }
      it { is_expected.to validate_inclusion_of(:distance3).in_array(Config::Workouts.dig(:breeze, :distances)) }
    end
  end
end

