class AddBreedingSlotReferenceToBreeding < ActiveRecord::Migration[8.1]
  def change
    add_reference :breedings, :slot, type: :bigint, index: true, foreign_key: { to_table: :breeding_slots }
  end
end

