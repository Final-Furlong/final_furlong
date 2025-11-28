RSpec.describe Racing::RaceResult do
  describe "associations" do
    it { is_expected.to belong_to(:track_surface).class_name("Racing::TrackSurface").with_foreign_key(:surface_id).inverse_of(:completed_races) }
    it { is_expected.to have_many(:horses).class_name("Racing::RaceResultHorse").inverse_of(:race).dependent(:delete_all) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:race_type) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:distance) }
    it { is_expected.to validate_presence_of(:purse) }
    it { is_expected.to validate_numericality_of(:number).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(50) }
    it { is_expected.to validate_numericality_of(:distance).is_greater_than_or_equal_to(5.0).is_less_than_or_equal_to(24.0) }
    it { is_expected.to validate_numericality_of(:time_in_seconds).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(1_000) }
    it { is_expected.to validate_numericality_of(:purse).only_integer.is_greater_than_or_equal_to(10_000).is_less_than_or_equal_to(20_000_000) }
    it { is_expected.to validate_inclusion_of(:split).in_array(described_class::SPLITS) }
    it { is_expected.to validate_inclusion_of(:race_type).in_array(Config::Racing.all_types) }
    it { is_expected.to validate_inclusion_of(:age).in_array(Config::Racing.ages) }
    it { is_expected.to validate_inclusion_of(:condition).in_array(Config::Racing.conditions.map(&:downcase)) }
    it { is_expected.to validate_inclusion_of(:grade).in_array(Config::Racing.grades).allow_blank }

    context "when grade is present" do
      subject(:result) { described_class.new(grade: "Ungraded") }

      it { is_expected.to validate_presence_of :name }
    end

    context "when race type is claiming" do
      subject(:result) { described_class.new(race_type: "claiming") }

      it { is_expected.to validate_numericality_of(:claiming_price).only_integer.is_greater_than_or_equal_to(5_000).is_less_than_or_equal_to(50_000) }
    end
  end
end

