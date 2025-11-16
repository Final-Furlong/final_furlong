# frozen_string_literal: true

class UpdateRaceScheduleDays < ActiveRecord::Migration[8.1]
  def up
    days = [
      { number: 98, date: "2025-12-06" },
      { number: 99, date: "2025-12-10" },
      { number: 100, date: "2025-12-13" },
      { number: 101, date: "2025-12-17" },
      { number: 102, date: "2025-12-20" },
      { number: 103, date: "2025-12-24" },
      { number: 104, date: "2025-12-27" },
      { number: 105, date: "2025-12-31" }
    ]
    days.each do |day_info|
      Racing::RaceSchedule.where(day_number: day_info[:number]).where(date: day_info[:date]..).find_each do |schedule|
        schedule.update(date: day_info[:date])
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

