class AddAutoFlagToWorkouts < ActiveRecord::Migration[8.1]
  def change
    add_column :workouts, :auto, :boolean, default: false, null: false
    add_index :workouts, :auto
  end
end

