RSpec.describe Racing::TrainingSchedule do
  describe "associations" do
    it { is_expected.to belong_to(:stable).class_name("Account::Stable") }

    it { is_expected.to have_many(:training_schedule_horses).class_name("Racing::TrainingScheduleHorse") }
    it { is_expected.to have_many(:horses).class_name("Horses::Horse").through(:training_schedule_horses) }
  end

  describe "validations" do
    subject(:schedule) { build(:training_schedule) }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:stable_id) }

    it "requires at least one activity on a day" do
      schedule = described_class.new(name: "Foo")

      expect(schedule).not_to be_valid
      expect(schedule.errors[:base]).to eq(["At least one activity must be selected"])
    end

    it "requires activity to have a distance" do
      schedule = described_class.new(name: "Foo", sunday_activities: { activity1: "walk" })

      expect(schedule).not_to be_valid
      expect(schedule.errors[:base]).to eq(["At least one activity must be selected"])
    end

    context "when activity + distance are set" do
      it "is valid" do
        schedule = described_class.new(name: "Foo", stable: build_stubbed(:stable))
        schedule.sunday_activities = { activity1: "walk", distance1: 6 }
        expect(schedule).to be_valid
      end
    end
  end
end

