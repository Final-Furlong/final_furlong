describe Horses::Horse::Racehorse do
  describe "associations" do
    it { is_expected.to have_one(:training_schedule).class_name("Racing::TrainingSchedule").through(:training_schedules_horse) }
    it { is_expected.to have_one(:training_schedules_horse).class_name("Racing::TrainingScheduleHorse").dependent(:destroy) }
  end
end

