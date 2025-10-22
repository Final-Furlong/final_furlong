RSpec.shared_examples "a horse" do
  describe "associations" do
    it { is_expected.to belong_to(:breeder).class_name("Account::Stable") }
    it { is_expected.to belong_to(:owner).class_name("Account::Stable") }
    it { is_expected.to belong_to(:sire).class_name("Horses::Horse").optional }
    it { is_expected.to belong_to(:dam).class_name("Horses::Horse").optional }
    it { is_expected.to belong_to(:location_bred).class_name("Location") }

    it { is_expected.to have_one(:appearance).class_name("Horses::Appearance").dependent(:delete) }
    it { is_expected.to have_one(:horse_attributes).class_name("Horses::Attributes").dependent(:delete) }
    it { is_expected.to have_one(:genetics).class_name("Horses::Genetics").dependent(:delete) }
    it { is_expected.to have_one(:training_schedule).class_name("Racing::TrainingSchedule").through(:training_schedules_horse) }
    it { is_expected.to have_one(:training_schedules_horse).class_name("Racing::TrainingScheduleHorse").dependent(:destroy) }
    it { is_expected.to have_one(:auction_horse).class_name("Auctions::Horse").dependent(:destroy) }
    it { is_expected.to have_many(:race_result_finishes).class_name("Racing::RaceResultHorse").dependent(:delete_all) }
    it { is_expected.to have_many(:race_results).class_name("Racing::RaceResult").through(:race_result_finishes) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:date_of_birth) }
  end
end

