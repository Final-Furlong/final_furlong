RSpec.describe Horses::RacehorsesQuery do
  subject(:query) { described_class.new }

  describe ".all_racehorses" do
    it "returns horses who are racehorses" do
      racehorse = create(:horse, :racehorse)
      stud = create(:horse, :stud)

      result = query.all_racehorses
      expect(result).to include racehorse
      expect(result).not_to include stud
    end
  end

  describe ".without_training_schedules" do
    it "returns horses who do not have a training schedule" do
      horse_with_schedule = create(:horse, :racehorse)
      create(:training_schedule_horse, horse: horse_with_schedule)
      horse_without_schedule = create(:horse, :racehorse)

      result = query.without_training_schedules
      expect(result).to include horse_without_schedule
      expect(result).not_to include horse_with_schedule
    end

    it "does not return non-racehorses" do
      horse_without_schedule = create(:horse, :stud)

      result = query.without_training_schedules
      expect(result).not_to include horse_without_schedule
    end
  end

  describe ".with_training_schedules" do
    it "returns horses who have matching training schedule" do
      horse_with_schedule = create(:horse, :racehorse)
      schedule = create(:training_schedule)
      create(:training_schedule_horse, training_schedule: schedule, horse: horse_with_schedule)
      horse_with_other_schedule = create(:horse, :racehorse)
      create(:training_schedule_horse, horse: horse_with_other_schedule)
      horse_without_schedule = create(:horse, :racehorse)

      result = query.with_training_schedule(schedule)
      expect(result).to include horse_with_schedule
      expect(result).not_to include horse_with_other_schedule, horse_without_schedule
    end

    it "does not return non-racehorses" do
      horse_with_schedule = create(:horse, :stud)
      schedule = create(:training_schedule)
      create(:training_schedule_horse, training_schedule: schedule, horse: horse_with_schedule)

      result = query.with_training_schedule(schedule)
      expect(result).not_to include horse_with_schedule
    end
  end
end

