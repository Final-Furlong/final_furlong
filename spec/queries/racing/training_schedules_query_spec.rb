RSpec.describe Racing::TrainingSchedulesQuery do
  subject(:query) { described_class.new }

  describe "#with_stable" do
    it "returns schedules for the stable" do
      stable = create(:stable)
      stable_schedule = create(:training_schedule, stable:)
      other_schedule = create(:training_schedule)

      result = query.with_stable(stable)
      expect(result).to include stable_schedule
      expect(result).not_to include other_schedule
    end
  end

  describe "#ordered" do
    it "returns schedules sorted by name" do
      schedule1 = create(:training_schedule, name: "AAA")
      schedule2 = create(:training_schedule, name: "BBB")

      result = query.ordered
      expect(result).to eq([schedule1, schedule2])
    end
  end
end

