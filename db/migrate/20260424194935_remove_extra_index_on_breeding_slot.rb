class RemoveExtraIndexOnBreedingSlot < ActiveRecord::Migration[8.1]
  def change
    remove_index :breeding_slots, :month, if_exists: true
  end
end

