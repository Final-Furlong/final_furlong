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
    it { is_expected.to validate_numericality_of(:days).only_integer.is_greater_than_or_equal_to(0) }
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

    describe ".current_year" do
      it "returns correct records" do
        travel_to Date.new(Date.current.year, 1, 10) do
          current_year = create(:boarding, start_date: Date.current - 5.days, end_date: nil)
          recently_ended = create(:boarding, start_date: 5.days.ago, end_date: 2.days.ago)
          last_year = create(:boarding, start_date: Date.current - 15.days, end_date: nil)
          last_year_ended_this_year = create(:boarding, start_date: Date.current - 15.days, end_date: Date.current - 1.day)
          last_year_ended = create(:boarding, start_date: Date.current - 15.days, end_date: Date.current - 12.days)

          result = described_class.current_year
          expect(result).to include current_year, recently_ended, last_year, last_year_ended_this_year
          expect(result).not_to include last_year_ended
        end
      end
    end
  end

  describe "#today?" do
    context "when start date is today" do
      it "returns true" do
        boarding = build_stubbed(:boarding, start_date: Date.current)
        expect(boarding.today?).to be true
      end
    end

    context "when start date is in the past" do
      it "returns true" do
        boarding = build_stubbed(:boarding, start_date: Date.current - 1.day)
        expect(boarding.today?).to be false
      end
    end

    context "when start date is in the future" do
      it "returns true" do
        boarding = build_stubbed(:boarding, start_date: Date.current + 1.day)
        expect(boarding.today?).to be false
      end
    end
  end
end

