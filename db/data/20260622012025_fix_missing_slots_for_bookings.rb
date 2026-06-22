# frozen_string_literal: true

class FixMissingSlotsForBookings < ActiveRecord::Migration[8.1]
  def up
    Horses::Breeding.where.not(date: nil).where(slot: nil).find_each do |breeding|
      slot = Breeding::Slot.where('end_day >= ?', breeding.date.day).where(month: breeding.date.month).order(end_day: :asc).first
      breeding.update(slot:)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
