class CreateBreedingSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :breeding_slots do |t|
      t.integer :month, null: false, index: true
      t.integer :start_day, null: false, index: true
      t.integer :end_day, null: false, index: true

      t.timestamps
    end

    add_index :breeding_slots, %i[month start_day end_day], unique: true
  end
end

