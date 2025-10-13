RSpec.describe Racing::RaceSchedule do
  describe "associations" do
    it { is_expected.to belong_to(:track_surface).class_name("Racing::TrackSurface").inverse_of(:scheduled_races) }
  end

  describe "validations" do
    subject(:schedule) { build(:race_schedule) }

    it { is_expected.to validate_presence_of(:day_number) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:race_type) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:distance) }
    it { is_expected.to validate_presence_of(:purse) }
    it { is_expected.to validate_numericality_of(:day_number).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(105).allow_nil }
    it { is_expected.to validate_numericality_of(:number).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(50) }
    it { is_expected.to validate_inclusion_of(:race_type).in_array(described_class::RACE_TYPES) }
    it { is_expected.to validate_inclusion_of(:age).in_array(described_class::RACE_AGES) }
    it { is_expected.to validate_numericality_of(:distance).is_greater_than_or_equal_to(5.0).is_less_than_or_equal_to(24.0) }
    it { is_expected.to validate_inclusion_of(:grade).in_array(described_class::RACE_GRADES).allow_blank }
    it { is_expected.to validate_numericality_of(:purse).only_integer.is_greater_than_or_equal_to(10_000).is_less_than_or_equal_to(20_000_000) }

    context "when grade is present" do
      subject(:schedule) { described_class.new(grade: "Ungraded") }

      it { is_expected.to validate_presence_of :name }
    end
  end
end

