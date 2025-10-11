RSpec.describe GameAlert do
  describe "validations" do
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_length_of(:message).is_at_least(10) }

    describe "end time" do
      subject(:alert) { described_class.new(start_time: DateTime.current) }

      it { is_expected.to validate_comparison_of(:end_time).is_greater_than(:start_time).allow_nil }
    end
  end
end

