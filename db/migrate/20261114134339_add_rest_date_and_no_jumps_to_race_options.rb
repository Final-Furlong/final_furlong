class AddRestDateAndNoJumpsToRaceOptions < ActiveRecord::Migration[8.1]
  def change
    add_column :race_options, :never_switch_to_jumps, :boolean, null: false, default: false
    add_column :race_options, :rest_date_for_racing, :date
    add_column :race_options, :rest_date_for_workouts, :date

    add_index :race_options, :never_switch_to_jumps
    add_index :race_options, :rest_date_for_racing
    add_index :race_options, :rest_date_for_workouts
  end
end

