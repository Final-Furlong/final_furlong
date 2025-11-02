RSpec.describe Racing::Jockey do
  describe "associations" do
    it { is_expected.to have_many(:race_result_horses).class_name("Racing::RaceResultHorse").inverse_of(:jockey) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:legacy_id) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:height_in_inches) }
    it { is_expected.to validate_presence_of(:weight) }
    it { is_expected.to validate_presence_of(:strength) }
    it { is_expected.to validate_presence_of(:acceleration) }
    it { is_expected.to validate_presence_of(:break_speed) }
    it { is_expected.to validate_presence_of(:min_speed) }
    it { is_expected.to validate_presence_of(:average_speed) }
    it { is_expected.to validate_presence_of(:max_speed) }
    it { is_expected.to validate_presence_of(:leading) }
    it { is_expected.to validate_presence_of(:midpack) }
    it { is_expected.to validate_presence_of(:off_pace) }
    it { is_expected.to validate_presence_of(:closing) }
    it { is_expected.to validate_presence_of(:consistency) }
    it { is_expected.to validate_presence_of(:courage) }
    it { is_expected.to validate_presence_of(:pissy) }
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_presence_of(:dirt) }
    it { is_expected.to validate_presence_of(:turf) }
    it { is_expected.to validate_presence_of(:steeplechase) }
    it { is_expected.to validate_presence_of(:fast) }
    it { is_expected.to validate_presence_of(:good) }
    it { is_expected.to validate_presence_of(:slow) }
    it { is_expected.to validate_presence_of(:wet) }
    it { is_expected.to validate_presence_of(:turning) }
    it { is_expected.to validate_presence_of(:looking) }
    it { is_expected.to validate_presence_of(:traffic) }
    it { is_expected.to validate_presence_of(:loaf_threshold) }
    it { is_expected.to validate_presence_of(:whip_seconds) }
    it { is_expected.to validate_presence_of(:experience) }
    it { is_expected.to validate_presence_of(:experience_rate) }
    it { is_expected.to validate_numericality_of(:acceleration).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:leading).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:off_pace).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:closing).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:midpack).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:consistency).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:courage).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:dirt).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:turf).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:steeplechase).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:fast).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:good).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:wet).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:slow).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:loaf_threshold).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:pissy).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:rating).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:strength).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:traffic).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:whip_seconds).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:experience).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:experience_rate).is_greater_than_or_equal_to(0.1).is_less_than_or_equal_to(0.5) }
    it { is_expected.to validate_numericality_of(:break_speed).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:min_speed).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:average_speed).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:max_speed).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:turning).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:height_in_inches).only_integer.is_greater_than_or_equal_to(48).is_less_than_or_equal_to(70) }
    it { is_expected.to validate_numericality_of(:looking).only_integer.is_greater_than_or_equal_to(5).is_less_than_or_equal_to(100) }
    it { is_expected.to validate_numericality_of(:weight).only_integer.is_greater_than_or_equal_to(35).is_less_than_or_equal_to(120) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(2) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(described_class::GENDERS) }
    it { is_expected.to validate_inclusion_of(:jockey_type).in_array(described_class::TYPES) }
    it { is_expected.to validate_inclusion_of(:status).in_array(described_class::STATUSES) }
  end
end

