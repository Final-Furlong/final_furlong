RSpec.shared_examples "a horse" do
  describe "associations" do
    it { is_expected.to belong_to(:breeder).class_name("Account::Stable") }
    it { is_expected.to belong_to(:owner).class_name("Account::Stable") }
    it { is_expected.to belong_to(:sire).class_name("Horses::Horse").optional }
    it { is_expected.to belong_to(:dam).class_name("Horses::Horse").optional }
    it { is_expected.to belong_to(:location_bred).class_name("Location") }

    it { is_expected.to have_one(:appearance).class_name("Horses::Appearance") }
    it { is_expected.to have_one(:training_schedules_horse).class_name("Racing::TrainingScheduleHorse") }
    it { is_expected.to have_one(:training_schedule).class_name("Racing::TrainingSchedule").through(:training_schedules_horse) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:date_of_birth) }
  end
end

