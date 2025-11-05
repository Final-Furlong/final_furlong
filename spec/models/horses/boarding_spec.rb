RSpec.describe Horses::Boarding do
  describe "associations" do
    it { is_expected.to belong_to(:horse) }
    it { is_expected.to belong_to(:location) }
  end

  describe "validations" do
    subject(:boarding) { described_class.new(horse: create(:horse), location: create(:location), start_date: Date.current) }

    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:days) }
    it { is_expected.to validate_comparison_of(:end_date).is_greater_than_or_equal_to(:start_date).allow_nil }
    it { is_expected.to validate_numericality_of(:days).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(30) }
  end

  describe "scopes" do
    describe ".current" do
      it "returns correct records" do
        horse = create(:horse)
        location = create(:location)
        current = create(:boarding, :current, horse:, location:)
        recently_ended = create(:boarding, start_date: 5.days.ago, end_date: 2.days.ago, days: 3, horse:, location:)
        past = create(:boarding, :past, horse:, location:)

        result = described_class.current
        expect(result).to include current
        expect(result).not_to include recently_ended, past
      end
    end
  end
end

