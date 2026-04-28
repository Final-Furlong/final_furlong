class AddTotalBookedCountToStallionOption < ActiveRecord::Migration[8.1]
  def change
    add_column :stallion_options, :total_booked_count, :integer, default: 0, null: false
    add_index :stallion_options, :total_booked_count
  end
end

