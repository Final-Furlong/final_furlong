RSpec.describe Racing::RaceRecord do
  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse").inverse_of(:race_records) }
  end

  describe "validations" do
    subject(:record) { build(:race_record) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:starts) }
    it { is_expected.to validate_presence_of(:stakes_starts) }
    it { is_expected.to validate_presence_of(:wins) }
    it { is_expected.to validate_presence_of(:stakes_wins) }
    it { is_expected.to validate_presence_of(:seconds) }
    it { is_expected.to validate_presence_of(:stakes_seconds) }
    it { is_expected.to validate_presence_of(:thirds) }
    it { is_expected.to validate_presence_of(:stakes_thirds) }
    it { is_expected.to validate_presence_of(:fourths) }
    it { is_expected.to validate_presence_of(:stakes_fourths) }
    it { is_expected.to validate_presence_of(:points) }
    it { is_expected.to validate_presence_of(:earnings) }
    it { is_expected.to validate_numericality_of(:starts).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:wins).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:stakes_starts).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:stakes_wins).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:seconds).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:stakes_seconds).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:thirds).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:stakes_thirds).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:fourths).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:stakes_fourths).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:year).only_integer }
    it { is_expected.to validate_comparison_of(:year).is_greater_than_or_equal_to(1996).is_less_than_or_equal_to(Date.current.year) }

    describe "result_type unique scope" do
      # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      it "is valid for different year/race type" do
        record1 = create(:race_record)
        record2 = build(:race_record, horse: record1.horse, year: record1.year, result_type: record1.result_type)

        expect(record2).not_to be_valid
        expect(record2.errors[:result_type]).to eq ["has already been taken"]

        record2.result_type = "turf"
        expect(record2).to be_valid

        record2.result_type = "dirt"
        record2.year = record2.year - 1
        expect(record2).to be_valid

        record2.year = record1.year
        record2.horse = build(:horse)
        expect(record2).to be_valid
      end
      # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
    end
  end
end

