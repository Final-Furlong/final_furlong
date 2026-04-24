# frozen_string_literal: true

class PopulateBreedingSlots < ActiveRecord::Migration[8.1]
  def up
    Config::Breedings.slots.each do |slot|
      Breeding::Slot.find_or_create_by(
        month: slot[:month],
        start_day: slot[:start],
        end_day: slot[:end]
      )
    end
  end

  def down
    Config::Breedings.slots.each do |slot|
      Breeding::Slot.find_by(
        month: slot[:month],
        start_day: slot[:start],
        end_day: slot[:end]
      )&.destroy
    end
  end
end

