# frozen_string_literal: true

class AssignBreedingSlotsToBreeding < ActiveRecord::Migration[8.1]
  def up
    Horses::Breeding.where(slot: nil).find_each do |breeding|
      slot = Breeding::Slot.where("? <= end_day", breeding.date.day).find_by(month: breeding.date.month)
      breeding.update(slot:)
    end
  end

  def down
    # rubocop:disable Rails/SkipsModelValidations
    Horses::Breeding.where.not(slot: nil).update_all(slot_id: nil)
    # rubocop:enable Rails/SkipsModelValidations
  end
end

