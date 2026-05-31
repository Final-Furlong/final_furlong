# frozen_string_literal: true

class Update2025RaceScheduleDates < ActiveRecord::Migration[8.1]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Racing::RaceSchedule.where(day_number: 98, date: "2025-12-06").update_all(date: "2026-12-09")
    Racing::RaceSchedule.where(day_number: 99, date: "2025-12-10").update_all(date: "2026-12-12")
    Racing::RaceSchedule.where(day_number: 100, date: "2025-12-13").update_all(date: "2026-12-16")
    Racing::RaceSchedule.where(day_number: 101, date: "2025-12-17").update_all(date: "2026-12-19")
    Racing::RaceSchedule.where(day_number: 102, date: "2025-12-20").update_all(date: "2026-12-23")
    Racing::RaceSchedule.where(day_number: 103, date: "2025-12-24").update_all(date: "2026-12-26")
    Racing::RaceSchedule.where(day_number: 104, date: "2025-12-27").update_all(date: "2026-12-30")
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

