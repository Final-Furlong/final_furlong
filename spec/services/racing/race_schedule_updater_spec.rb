RSpec.describe Racing::RaceScheduleUpdater do
  context "when not all races have been run" do
    it "skips updating the schedule" do
      date = Date.new(2022, 1, 1)
      create(:race_schedule, day_number: 1, date:, number: 1)
      schedule = create(:race_schedule, date:, number: 2)
      create(:race_result, date:, number: 1)

      travel_to date do
        described_class.new.update_schedule
      end

      expect(schedule.reload.date).to eq date
    end
  end

  context "when the first set of races have run" do
    it "handles Sun being the first day of the new year" do
      date = Date.new(2022, 1, 1)
      schedule = create(:race_schedule, day_number: 1, date:, number: 1)
      create(:race_result, date:, number: 1)
      next_date = Date.new(2023, 1, 4)

      travel_to date do
        described_class.new.update_schedule
      end

      expect(schedule.reload.date).to eq next_date
    end

    it "handles Mon being the first day of the new year" do
      date = Date.new(2023, 1, 1)
      schedule = create(:race_schedule, day_number: 1, date:, number: 1)
      create(:race_result, date:, number: 1)
      next_date = Date.new(2024, 1, 3)

      described_class.new.update_schedule

      expect(schedule.reload.date).to eq next_date
    end

    it "handles Tues being the first day of the new year" do
      date = Date.new(2018, 1, 1)
      schedule = create(:race_schedule, day_number: 1, date:, number: 1)
      create(:race_result, date:, number: 1)
      next_date = Date.new(2019, 1, 2)

      described_class.new.update_schedule

      expect(schedule.reload.date).to eq next_date
    end

    it "handles Wed being the first day of the new year" do
      date = Date.new(2024, 1, 1)
      schedule = create(:race_schedule, day_number: 1, date:, number: 1)
      create(:race_result, date:, number: 1)
      next_date = Date.new(2025, 1, 1)

      described_class.new.update_schedule

      expect(schedule.reload.date).to eq next_date
    end

    it "handles Thurs being the first day of the new year" do
      date = Date.new(2014, 1, 1)
      schedule = create(:race_schedule, day_number: 1, date:, number: 1)
      create(:race_result, date:, number: 1)
      next_date = Date.new(2015, 1, 3)

      described_class.new.update_schedule

      expect(schedule.reload.date).to eq next_date
    end

    it "handles Fri being the first day of the new year" do
      date = Date.new(2020, 1, 1)
      schedule = create(:race_schedule, day_number: 1, date:, number: 1)
      create(:race_result, date:, number: 1)
      next_date = Date.new(2021, 1, 2)

      described_class.new.update_schedule

      expect(schedule.reload.date).to eq next_date
    end

    it "handles Sat being the first day of the new year" do
      date = Date.new(2021, 1, 1)
      schedule = create(:race_schedule, day_number: 1, date:, number: 1)
      create(:race_result, date:, number: 1)
      next_date = Date.new(2022, 1, 1)

      described_class.new.update_schedule

      expect(schedule.reload.date).to eq next_date
    end
  end

  it "handles Wed being the second day of the new year" do
    create(:race_schedule, day_number: 1, date: "2022-01-01", number: 1)
    create(:race_result, date: "2021-01-02", number: 1)
    schedule = create(:race_schedule, day_number: 2, date: "2021-01-06", number: 1)
    create(:race_result, date: "2021-01-06", number: 1)
    next_date = Date.new(2022, 1, 10)

    travel_to next_date do
      described_class.new.update_schedule
    end

    expect(schedule.reload.date).to eq Date.parse("2022-01-05")
  end

  it "handles Sat being the second day of the new year" do
    create(:race_schedule, day_number: 1, date: "2025-01-01", number: 1)
    create(:race_result, date: "2024-01-03", number: 1)
    schedule = create(:race_schedule, day_number: 2, date: "2024-01-05", number: 1)
    create(:race_result, date: "2024-01-06", number: 1)
    next_date = Date.new(2024, 1, 10)

    travel_to next_date do
      described_class.new.update_schedule
    end

    expect(schedule.reload.date).to eq Date.parse("2025-01-04")
  end

  context "when many sets of races need updating" do
    it "updates all the days" do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      schedule1 = create(:race_schedule, day_number: 1, date: "2025-01-01",
        number: 1)
      create(:race_result, date: "2025-01-01", number: 1)
      schedule2 = create(:race_schedule, day_number: 2, date: "2025-01-04",
        number: 1)
      create(:race_result, date: "2025-01-04", number: 1)
      schedule3 = create(:race_schedule, day_number: 3, date: "2025-01-08",
        number: 1)
      create(:race_result, date: "2025-01-08", number: 1)
      schedule4 = create(:race_schedule, day_number: 4, date: "2025-01-11",
        number: 1)
      create(:race_result, date: "2025-01-11", number: 1)
      schedule5 = create(:race_schedule, day_number: 5, date: "2025-01-15",
        number: 1)
      create(:race_result, date: "2025-01-15", number: 1)
      schedule6 = create(:race_schedule, day_number: 6, date: "2025-01-18",
        number: 1)
      create(:race_result, date: "2025-01-18", number: 1)
      schedule7 = create(:race_schedule, day_number: 7, date: "2025-01-22",
        number: 1)
      create(:race_result, date: "2025-01-22", number: 1)
      schedule8 = create(:race_schedule, day_number: 8, date: "2025-01-25",
        number: 1)
      create(:race_result, date: "2025-01-25", number: 1)
      schedule9 = create(:race_schedule, day_number: 9, date: "2025-01-29",
        number: 1)
      create(:race_result, date: "2025-01-29", number: 1)
      date = Date.new(2025, 2, 3)

      travel_to date do
        described_class.new.update_schedule
      end

      expect(schedule1.reload.date).to eq Date.parse("2026-01-03")
      expect(schedule2.reload.date).to eq Date.parse("2026-01-07")
      expect(schedule3.reload.date).to eq Date.parse("2026-01-10")
      expect(schedule4.reload.date).to eq Date.parse("2026-01-14")
      expect(schedule5.reload.date).to eq Date.parse("2026-01-17")
      expect(schedule6.reload.date).to eq Date.parse("2026-01-21")
      expect(schedule7.reload.date).to eq Date.parse("2026-01-24")
      expect(schedule8.reload.date).to eq Date.parse("2026-01-28")
      expect(schedule9.reload.date).to eq Date.parse("2026-01-31")
    end
  end

  context "when carrying over from a year with 105 race days" do
    it "does not update the final race day" do # rubocop:disable RSpec/ExampleLength
      create(:race_schedule, day_number: 102, date: "2025-12-24", number: 1)
      create(:race_schedule, day_number: 103, date: "2025-12-27", number: 1)
      schedule1 = create(:race_schedule, day_number: 104, date: "2024-12-25", number: 1)
      create(:race_result, date: "2024-12-25", number: 1)
      schedule2 = create(:race_schedule, day_number: 105, date: "2024-12-28", number: 1)
      create(:race_result, date: "2024-12-28", number: 1)
      date = Date.new(2025, 2, 15)

      travel_to date do
        described_class.new.update_schedule
      end

      expect(schedule1.reload.date).to eq Date.parse("2025-12-31")
      expect(schedule2.reload.date).to eq Date.parse("2024-12-28")
    end
  end

  context "when carrying over to a year with 105 race days" do
    it "updates not update the final race day" do # rubocop:disable RSpec/ExampleLength
      create(:race_schedule, day_number: 102, date: "2024-12-18", number: 1)
      create(:race_schedule, day_number: 103, date: "2024-12-21", number: 1)
      schedule1 = create(:race_schedule, day_number: 104, date: "2023-12-25", number: 1)
      create(:race_result, date: "2023-12-25", number: 1)
      schedule2 = create(:race_schedule, day_number: 105, date: "2020-12-30", number: 1)
      date = Date.new(2025, 2, 15)

      travel_to date do
        described_class.new.update_schedule
      end

      expect(schedule1.reload.date).to eq Date.parse("2024-12-25")
      expect(schedule2.reload.date).to eq Date.parse("2024-12-28")
    end
  end

  private

  def date
    @date ||= Date.current
  end

  def race_result
    @race_result ||= create(:race_result, date:)
  end
end

