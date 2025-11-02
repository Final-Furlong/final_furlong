class RecreateTrainingScheduleIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :training_schedules, :sunday_activities, using: :gin, algorithm: :concurrently, if_not_exists: true
    add_index :training_schedules, :monday_activities, using: :gin, algorithm: :concurrently, if_not_exists: true
    add_index :training_schedules, :tuesday_activities, using: :gin, algorithm: :concurrently, if_not_exists: true
    add_index :training_schedules, :wednesday_activities, using: :gin, algorithm: :concurrently, if_not_exists: true
    add_index :training_schedules, :thursday_activities, using: :gin, algorithm: :concurrently, if_not_exists: true
    add_index :training_schedules, :friday_activities, using: :gin, algorithm: :concurrently, if_not_exists: true
    add_index :training_schedules, :saturday_activities, using: :gin, algorithm: :concurrently, if_not_exists: true
  end
end

