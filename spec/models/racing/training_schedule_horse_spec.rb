RSpec.describe Racing::TrainingScheduleHorse do
  describe "associations" do
    it { is_expected.to belong_to(:training_schedule).class_name("Racing::TrainingSchedule") }
  end

  describe "validations" do
    it "validates unique horse" do
      schedule1 = create(:training_schedule_horse)

      schedule2 = build(:training_schedule_horse, horse: schedule1.horse)
      expect(schedule2).not_to be_valid
      expect(schedule2.errors[:horse_id]).to eq(["has already been taken"])
    end
  end
end

