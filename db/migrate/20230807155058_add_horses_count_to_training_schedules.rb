class AddHorsesCountToTrainingSchedules < ActiveRecord::Migration[7.0]
  def self.up
    add_column :training_schedules, :horses_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :training_schedules, :horses_count
  end
end

